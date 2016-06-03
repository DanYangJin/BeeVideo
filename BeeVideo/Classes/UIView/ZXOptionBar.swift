//
//  ZXOptionBar.swift
//  ZXOptionBar-Swift
//
//
//

import UIKit

// MARK: - Enum - ZXOptionBarOrigin
enum ZXOptionBarOrigin{
    case ZXOptionBarOriginTap, ZXOptionBarOriginSlide
}

// MARK: - ZXOptionBarDataSource
protocol ZXOptionBarDataSource: NSObjectProtocol {
    
    func numberOfColumnsInOptionBar(optionBar: ZXOptionBar) -> Int
    func optionBar(optionBar: ZXOptionBar, cellForColumnAtIndex index: Int) -> ZXOptionBarCell
}

// MARK: - ZXOptionBarDelegate
@objc protocol ZXOptionBarDelegate: UIScrollViewDelegate {
    
    // Display customization
    optional func optionBar(optionBar: ZXOptionBar, willDisplayCell cell: ZXOptionBarCell, forColumnAtIndex index: Int)
    optional func optionBar(optionBar: ZXOptionBar, didEndDisplayingCell cell: ZXOptionBarCell, forColumnAtIndex index: Int)
    
    // Variable height support
    optional func optionBar(optionBar: ZXOptionBar, widthForColumnsAtIndex index: Int) -> Float
    
    //Select
    optional func optionBar(optionBar: ZXOptionBar, didSelectColumnAtIndex index: Int)
    optional func optionBar(optionBar: ZXOptionBar, didDeselectColumnAtIndex index: Int)
    
    //Reload
    optional func optionBarWillReloadData(optionBar: ZXOptionBar)
    optional func optionBarDidReloadData(optionBar: ZXOptionBar)

}

// MARK: - ZXOptionBar
class ZXOptionBar: UIScrollView {
    
    // Mark: Var
    weak var barDataSource: ZXOptionBarDataSource?
    weak var barDelegate: ZXOptionBarDelegate?
    internal var selectedIndex: Int?
    
    // MARK: Private Var
    private var reusableOptionCells: Dictionary<String, NSMutableArray>!
    
    private var visibleItems: Dictionary<String, ZXOptionBarCell>!

    private var flags: ZXOptionBarFlag = ZXOptionBarFlag()
    
    private var dividerWidth : Float = 0.0
    
    // MARK: Private ZXOptionBarFlag
    private struct ZXOptionBarFlag {
        
        var respondsToDidSelectColumnAtIndexSelector: Bool = false
        var respondsToDeselectColumnAtIndex: Bool = false
        
        var layoutSubviewsReentrancyGuard: Bool = true
    }

    
    // MARK: Method
    convenience init(frame: CGRect, barDelegate: ZXOptionBarDelegate, barDataSource:ZXOptionBarDataSource ) {
        self.init(frame: frame)
        self.delegate = delegate
        self.barDataSource = barDataSource
        self.barDelegate = barDelegate

        flags.respondsToDidSelectColumnAtIndexSelector = self.barDelegate!.respondsToSelector(#selector(ZXOptionBarDelegate.optionBar(_:didSelectColumnAtIndex:)))
        flags.respondsToDeselectColumnAtIndex = self.barDelegate!.respondsToSelector(#selector(ZXOptionBarDelegate.optionBar(_:didDeselectColumnAtIndex:)))
        
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = UIColor.whiteColor()
        self.scrollsToTop = false
        
        var totleWidth: Float = 0.0;
        if columnCount() >= 1 {
            for i in 0...(self.columnCount()-1) {
                totleWidth += self.columnWidthAtIndex(i)
            }
        }
        self.contentSize = CGSizeMake(CGFloat(totleWidth), self.bounds.size.height);
        
        reusableOptionCells = Dictionary<String, NSMutableArray>()
        visibleItems = Dictionary<String, ZXOptionBarCell>()

    }
    
    internal func selectColumnAtIndex(index: Int, origin:ZXOptionBarOrigin) {
        if !self.indexIsValid(index){
            return
        }
        
        if let cell: ZXOptionBarCell = self.cellForColumnAtIndex(index) {
            if self.selectedIndex != nil {
                self.deselectColumnAtIndex(self.selectedIndex!)
            }
            cell.selected = true
            self.selectedIndex = index
        }
        
        if origin == ZXOptionBarOrigin.ZXOptionBarOriginTap {
            if flags.respondsToDidSelectColumnAtIndexSelector {
                self.barDelegate!.optionBar!(self, didSelectColumnAtIndex: index)
            }
        }
        
        //self.scrollByIndex(index)
    }
    
    internal func deselectColumnAtIndex(index: Int) {
        if !self.indexIsValid(index) || !self.indexIsValid(self.selectedIndex!) {
            return
        }
        
        if index == self.selectedIndex {
            if let cell: ZXOptionBarCell = self.cellForColumnAtIndex(index) {
                cell.selected = false
                self.selectedIndex = 0
                cell.setNeedsDisplay()
            }
            
            if flags.respondsToDeselectColumnAtIndex {
                self.barDelegate!.optionBar!(self, didDeselectColumnAtIndex: index)
            }
        }
    }
    
    internal func dequeueReusableCellWithIdentifier(identifier: String) -> AnyObject? {
        let array: NSMutableArray? = self.reusableOptionCells[identifier]
        if array != nil {
            if let c: AnyObject = array!.lastObject {
                array!.removeLastObject()
                c.prepareForReuse()
                return c
            }
        }
        return nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if flags.layoutSubviewsReentrancyGuard {
            flags.layoutSubviewsReentrancyGuard = false
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            self.layoutCells()
            CATransaction.commit()
            
            flags.layoutSubviewsReentrancyGuard = true
        }
    }
    
    func reloadData(){
        var totleWidth: Float = 0.0;
        if columnCount() >= 1 {
            for i in 0...(self.columnCount()-1) {
                totleWidth += self.columnWidthAtIndex(i)
            }
            
        }
        self.contentSize = CGSizeMake(CGFloat(totleWidth), self.bounds.size.height);
        reusableOptionCells = Dictionary<String, NSMutableArray>()
        visibleItems = Dictionary<String, ZXOptionBarCell>()
        self.layoutSubviews()
    }
    
    
    func setDividerWidth(dividerWidth width: Float){
        self.dividerWidth = width
        reloadData()
    }
    
}

// MARK: - ZXOptionBar - Private Extension
extension ZXOptionBar {
    
    private func scrollByIndex(index: Int) {
        
        var columnWidthCountLeft: Float = 0.0
        for i in 0 ..< index {
            columnWidthCountLeft += self.columnWidthAtIndex(i)
        }
        
        var columnWidthCountRight: Float = 0.0
        for i in index + 1 ..< self.columnCount() {
            columnWidthCountRight += self.columnWidthAtIndex(i)
        }
        
        if columnWidthCountLeft < Float(self.bounds.size.width) / 2.0 {
            self.setContentOffset(CGPointMake(0, self.contentOffset.y), animated: true)
        }else if (columnWidthCountRight < Float(self.bounds.size.width) / 2.0) {
            self.setContentOffset(CGPointMake(self.contentSize.width - self.bounds.size.width, self.contentOffset.y), animated: true)
        }else {
            var columnWidthCount: Float = 0.0
            for i in 0 ..< index {
                columnWidthCount += self.columnWidthAtIndex(i)
            }
            columnWidthCount += self.columnWidthAtIndex(index) / 2.0
            columnWidthCount -= Float(self.bounds.size.width) / 2.0
            self.setContentOffset(CGPointMake(CGFloat(columnWidthCount), self.contentOffset.y), animated: true)
        }
    }
    
    private func layoutCells() {
        let visible = self.visibleRect()
        // Example:
        // old:            0 1 2 3 4 5 6 7
        // new:                2 3 4 5 6 7 8 9
        // to remove:      0 1
        // to add:                         8 9
        
        let oldVisibleIndex: Array<String> = self.indexsForVisibleColumns()
        let newVisibleIndex: Array<String> = self.indexsForColumnInRect(visible)
        
        let indexsToRemove: NSMutableArray = NSMutableArray(array: oldVisibleIndex)
        indexsToRemove.removeObjectsInArray(newVisibleIndex)
        
        let indexsToAdd: NSMutableArray = NSMutableArray(array: newVisibleIndex)
        indexsToAdd.removeObjectsInArray(oldVisibleIndex)
        
        
        //delete the cells which frame out
        for i in indexsToRemove {
            let cell: ZXOptionBarCell = self.cellForColumnAtIndex(self.indexFromIdentifyKey(i as! String))!
            self.enqueueReusableCell(cell)
            cell.removeFromSuperview()
            self.visibleItems.removeValueForKey(i as! String)
        }
        
        //add the new cell which frame in
        for i in indexsToAdd {
            
            let indexToAdd: Int = self.indexFromIdentifyKey(i as! String)
            
            let cell: ZXOptionBarCell = self.barDataSource!.optionBar(self, cellForColumnAtIndex: indexToAdd)
            cell.frame = self.rectForColumnAtIndex(indexToAdd)
            cell.prepareForDisplay()
            cell.index = indexToAdd
            cell.selected = (indexToAdd == self.selectedIndex)
            
            if self.barDelegate!.respondsToSelector(#selector(ZXOptionBarDelegate.optionBar(_:willDisplayCell:forColumnAtIndex:))) {
                self.barDelegate!.optionBar!(self, willDisplayCell: cell, forColumnAtIndex: indexToAdd)
            }
            
            self.addSubview(cell)
            self.visibleItems.updateValue(cell, forKey: (i as! String))
            
        }
    }
    
    private func enqueueReusableCell(cell: ZXOptionBarCell) {
        if let identifier: String = cell.reuseIdentifier {
            var array: NSMutableArray? = self.reusableOptionCells[identifier]
            if (array == nil) {
                array = NSMutableArray()
                self.reusableOptionCells.updateValue(array!, forKey: identifier)
            }
            array?.addObject(cell)
            
        }else{
            return
        }
    }
    
    private func visibleRect() -> CGRect {
        return CGRectMake(self.contentOffset.x, self.contentOffset.y, self.bounds.size.width, self.bounds.size.height)
    }
    
    private func indexsForVisibleColumns() -> Array<String> {
        var keyArr: [String] = []
        for (key, _) in self.visibleItems {
            keyArr.append(key)
        }
        return keyArr
    }
    
    private func indexsForColumnInRect(rect: CGRect) -> Array<String> {
        
        var indexs: [String] = []
        if columnCount() > 0 {
            for column in 0...(self.columnCount()-1) {
                let cellRect: CGRect = self.rectForColumnAtIndex(column)
                if CGRectIntersectsRect(cellRect, rect) {
                    indexs.append(self.identifyKeyFromIndex(column))
                }
            }
        }
        return indexs
    }
    
    private func columnCount() -> Int {
        return self.barDataSource!.numberOfColumnsInOptionBar(self)
    }
    
    
    private func columnWidthAtIndex(index: Int) -> Float {
        if let result = self.barDelegate!.optionBar?(self, widthForColumnsAtIndex: index) {
            if index == self.columnCount() - 1 {
                return result
            }
            return result + dividerWidth
        }else{
            return 0.0
        }
    }
    
    private func rectForColumnAtIndex(index: Int) -> CGRect {
        let width: Float = self.columnWidthAtIndex(index);
        if index == columnCount() - 1 {
            return CGRectMake(CGFloat((width + dividerWidth) * Float(index)), 0, CGFloat(width), self.bounds.size.height)
        }
        return CGRectMake(CGFloat((width) * Float(index)), 0, CGFloat(width - dividerWidth), self.bounds.size.height)
    }

    
    private func cellForColumnAtIndex(index: Int) -> ZXOptionBarCell? {
        return self.visibleItems[self.identifyKeyFromIndex(index)]
    }
    
    
    private func identifyKeyFromIndex(index: Int) -> String {
        return "\(index)"
    }
    
    private func indexFromIdentifyKey(identifyKey: String) -> Int {
        if let index = Int(identifyKey) {
            return index
        }else{
            return 0
        }
    }
    
    private func indexIsValid(index: Int) -> Bool {
        return index >= 0 && index < self.columnCount()
    }
}