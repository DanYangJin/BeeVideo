//
//  ZXOptionBar.swift
//  ZXOptionBar-Swift
//
//
//

import UIKit

// MARK: - Enum - ZXOptionBarOrigin
enum ZXOptionBarOrigin{
    case zxOptionBarOriginTap, zxOptionBarOriginSlide
}

// MARK: - ZXOptionBarDataSource
protocol ZXOptionBarDataSource: NSObjectProtocol {
    
    func numberOfColumnsInOptionBar(_ optionBar: ZXOptionBar) -> Int
    func optionBar(_ optionBar: ZXOptionBar, cellForColumnAtIndex index: Int) -> ZXOptionBarCell
}

// MARK: - ZXOptionBarDelegate
@objc protocol ZXOptionBarDelegate: UIScrollViewDelegate {
    
    // Display customization
    @objc optional func optionBar(_ optionBar: ZXOptionBar, willDisplayCell cell: ZXOptionBarCell, forColumnAtIndex index: Int)
    @objc optional func optionBar(_ optionBar: ZXOptionBar, didEndDisplayingCell cell: ZXOptionBarCell, forColumnAtIndex index: Int)
    
    // Variable height support
    @objc optional func optionBar(_ optionBar: ZXOptionBar, widthForColumnsAtIndex index: Int) -> Float
    
    //Select
    @objc optional func optionBar(_ optionBar: ZXOptionBar, didSelectColumnAtIndex index: Int)
    @objc optional func optionBar(_ optionBar: ZXOptionBar, didDeselectColumnAtIndex index: Int)
    
    //Reload
    @objc optional func optionBarWillReloadData(_ optionBar: ZXOptionBar)
    @objc optional func optionBarDidReloadData(_ optionBar: ZXOptionBar)

}

// MARK: - ZXOptionBar
class ZXOptionBar: UIScrollView {
    
    // Mark: Var
    weak var barDataSource: ZXOptionBarDataSource?
    weak var barDelegate: ZXOptionBarDelegate?
    internal var selectedIndex: Int?
    
    // MARK: Private Var
    fileprivate var reusableOptionCells: Dictionary<String, NSMutableArray>!
    
    fileprivate var visibleItems: Dictionary<String, ZXOptionBarCell>!

    fileprivate var flags: ZXOptionBarFlag = ZXOptionBarFlag()
    
    fileprivate var dividerWidth : Float = 0.0
    
    fileprivate var oldCount : Int = 0
    
    // MARK: Private ZXOptionBarFlag
    fileprivate struct ZXOptionBarFlag {
        
        var respondsToDidSelectColumnAtIndexSelector: Bool = false
        var respondsToDeselectColumnAtIndex: Bool = false
        
        var layoutSubviewsReentrancyGuard: Bool = true
    }

    
    // MARK: Method
    convenience init(frame: CGRect, barDelegate: ZXOptionBarDelegate, barDataSource:ZXOptionBarDataSource ) {
        self.init(frame: frame, barDelegate: barDelegate, barDataSource:barDataSource, dividerWidth: 0)
        
    }
    
    init(frame: CGRect, barDelegate: ZXOptionBarDelegate, barDataSource:ZXOptionBarDataSource, dividerWidth: Float) {
        super.init(frame: frame)
        self.dividerWidth = dividerWidth
        self.delegate = delegate
        self.barDataSource = barDataSource
        self.barDelegate = barDelegate
        
        flags.respondsToDidSelectColumnAtIndexSelector = self.barDelegate!.responds(to: #selector(ZXOptionBarDelegate.optionBar(_:didSelectColumnAtIndex:)))
        flags.respondsToDeselectColumnAtIndex = self.barDelegate!.responds(to: #selector(ZXOptionBarDelegate.optionBar(_:didDeselectColumnAtIndex:)))
        
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = UIColor.white
        self.scrollsToTop = false
        
        var totleWidth: Float = 0.0;
        oldCount = columnCount()
        if columnCount() >= 1 {
            for i in 0...(self.columnCount()-1) {
                totleWidth += self.columnWidthAtIndex(i)
            }
        }
        self.contentSize = CGSize(width: CGFloat(totleWidth), height: self.bounds.size.height);
        
        reusableOptionCells = Dictionary<String, NSMutableArray>()
        visibleItems = Dictionary<String, ZXOptionBarCell>()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func selectColumnAtIndex(_ index: Int, origin:ZXOptionBarOrigin) {
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
        
        if origin == ZXOptionBarOrigin.zxOptionBarOriginTap {
            if flags.respondsToDidSelectColumnAtIndexSelector {
                self.barDelegate!.optionBar!(self, didSelectColumnAtIndex: index)
            }
        }
        
    }
    
    internal func deselectColumnAtIndex(_ index: Int) {
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
    
    internal func dequeueReusableCellWithIdentifier(_ identifier: String) -> AnyObject? {
        let array: NSMutableArray? = self.reusableOptionCells[identifier]
        if array != nil {
            if let c: AnyObject = array!.lastObject as AnyObject? {
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
        self.contentOffset = CGPoint(x: 0, y: 0)
        var totleWidth: Float = 0.0;
        
        if oldCount >= 1 {
            for i in 0..<oldCount {
                let cell = self.cellForColumnAtIndex(i)
                cell?.removeFromSuperview()
            }
        }
        
        oldCount = columnCount()
        if columnCount() >= 1 {
            for i in 0...(self.columnCount()-1) {
                totleWidth += self.columnWidthAtIndex(i)
            }
        }
        self.contentSize = CGSize(width: CGFloat(totleWidth), height: self.bounds.size.height);
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
    
    fileprivate func scrollByIndex(_ index: Int) {
        
        var columnWidthCountLeft: Float = 0.0
        for i in 0 ..< index {
            columnWidthCountLeft += self.columnWidthAtIndex(i)
        }
        
        var columnWidthCountRight: Float = 0.0
        for i in index + 1 ..< self.columnCount() {
            columnWidthCountRight += self.columnWidthAtIndex(i)
        }
        
        if columnWidthCountLeft < Float(self.bounds.size.width) / 2.0 {
            self.setContentOffset(CGPoint(x: 0, y: self.contentOffset.y), animated: true)
        }else if (columnWidthCountRight < Float(self.bounds.size.width) / 2.0) {
            self.setContentOffset(CGPoint(x: self.contentSize.width - self.bounds.size.width, y: self.contentOffset.y), animated: true)
        }else {
            var columnWidthCount: Float = 0.0
            for i in 0 ..< index {
                columnWidthCount += self.columnWidthAtIndex(i)
            }
            columnWidthCount += self.columnWidthAtIndex(index) / 2.0
            columnWidthCount -= Float(self.bounds.size.width) / 2.0
            self.setContentOffset(CGPoint(x: CGFloat(columnWidthCount), y: self.contentOffset.y), animated: true)
        }
    }
    
    fileprivate func layoutCells() {
        let visible = self.visibleRect()
        // Example:
        // old:            0 1 2 3 4 5 6 7
        // new:                2 3 4 5 6 7 8 9
        // to remove:      0 1
        // to add:                         8 9
        
        let oldVisibleIndex: Array<String> = self.indexsForVisibleColumns()
        let newVisibleIndex: Array<String> = self.indexsForColumnInRect(visible)
        
        let indexsToRemove: NSMutableArray = NSMutableArray(array: oldVisibleIndex)
        indexsToRemove.removeObjects(in: newVisibleIndex)
        
        let indexsToAdd: NSMutableArray = NSMutableArray(array: newVisibleIndex)
        indexsToAdd.removeObjects(in: oldVisibleIndex)
        
        
        //delete the cells which frame out
        for i in indexsToRemove {
            let cell: ZXOptionBarCell = self.cellForColumnAtIndex(self.indexFromIdentifyKey(i as! String))!
            self.enqueueReusableCell(cell)
            cell.removeFromSuperview()
            self.visibleItems.removeValue(forKey: i as! String)
        }
        
        //add the new cell which frame in
        for i in indexsToAdd {
            
            let indexToAdd: Int = self.indexFromIdentifyKey(i as! String)
            
            let cell: ZXOptionBarCell = self.barDataSource!.optionBar(self, cellForColumnAtIndex: indexToAdd)
            cell.frame = self.rectForColumnAtIndex(indexToAdd)
            cell.prepareForDisplay()
            cell.index = indexToAdd
            cell.selected = (indexToAdd == self.selectedIndex)
            
            if self.barDelegate!.responds(to: #selector(ZXOptionBarDelegate.optionBar(_:willDisplayCell:forColumnAtIndex:))) {
                self.barDelegate!.optionBar!(self, willDisplayCell: cell, forColumnAtIndex: indexToAdd)
            }
            
            self.addSubview(cell)
            self.visibleItems.updateValue(cell, forKey: (i as! String))
            
        }
    }
    
    fileprivate func enqueueReusableCell(_ cell: ZXOptionBarCell) {
        if let identifier: String = cell.reuseIdentifier {
            var array: NSMutableArray? = self.reusableOptionCells[identifier]
            if (array == nil) {
                array = NSMutableArray()
                self.reusableOptionCells.updateValue(array!, forKey: identifier)
            }
            array?.add(cell)
            
        }else{
            return
        }
    }
    
    fileprivate func visibleRect() -> CGRect {
        return CGRect(x: self.contentOffset.x, y: self.contentOffset.y, width: self.bounds.size.width, height: self.bounds.size.height)
    }
    
    fileprivate func indexsForVisibleColumns() -> Array<String> {
        var keyArr: [String] = []
        for (key, _) in self.visibleItems {
            keyArr.append(key)
        }
        return keyArr
    }
    
    fileprivate func indexsForColumnInRect(_ rect: CGRect) -> Array<String> {
        
        var indexs: [String] = []
        if columnCount() > 0 {
            for column in 0...(self.columnCount()-1) {
                let cellRect: CGRect = self.rectForColumnAtIndex(column)
                if cellRect.intersects(rect) {
                    indexs.append(self.identifyKeyFromIndex(column))
                }
            }
        }
        return indexs
    }
    
    fileprivate func columnCount() -> Int {
        return self.barDataSource!.numberOfColumnsInOptionBar(self)
    }
    
    
    fileprivate func columnWidthAtIndex(_ index: Int) -> Float {
        if let result = self.barDelegate!.optionBar?(self, widthForColumnsAtIndex: index) {
            if index == self.columnCount() - 1 {
                return result
            }
            return result + dividerWidth
        }else{
            return 0.0
        }
    }
    
    fileprivate func rectForColumnAtIndex(_ index: Int) -> CGRect {
        let width: Float = self.columnWidthAtIndex(index);
        if index == columnCount() - 1 {
            return CGRect(x: CGFloat((width + dividerWidth) * Float(index)), y: 0, width: CGFloat(width), height: self.bounds.size.height)
        }
        return CGRect(x: CGFloat((width) * Float(index)), y: 0, width: CGFloat(width - dividerWidth), height: self.bounds.size.height)
    }

    
    func cellForColumnAtIndex(_ index: Int) -> ZXOptionBarCell? {
        return self.visibleItems[self.identifyKeyFromIndex(index)]
    }
    
    
    fileprivate func identifyKeyFromIndex(_ index: Int) -> String {
        return "\(index)"
    }
    
    fileprivate func indexFromIdentifyKey(_ identifyKey: String) -> Int {
        if let index = Int(identifyKey) {
            return index
        }else{
            return 0
        }
    }
    
    fileprivate func indexIsValid(_ index: Int) -> Bool {
        return index >= 0 && index < self.columnCount()
    }
}
