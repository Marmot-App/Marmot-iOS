//
//  Stem
//
//  Copyright (c) 2017 linhay - https://github.com/linhay
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

import UIKit

public extension Stem where Base: UITableView {
  
  public func update(_ colusre: (_ tableView: UITableView) -> Void) {
    base.beginUpdates()
    colusre(base)
    base.endUpdates()
  }
  
  public func scroll(to row: Int,in section: Int,at position: UITableView.ScrollPosition,animated: Bool) {
    let indexPath = IndexPath(row: row, section: section)
    base.scrollToRow(at: indexPath, at: position, animated: animated)
  }
  
  public func insertRow(at indexPath: IndexPath,with animation: UITableView.RowAnimation) {
    base.insertRows(at: [indexPath], with: animation)
  }
  
  public func insert(row: Int, in section: Int,with animation: UITableView.RowAnimation) {
    let indexPath = IndexPath(row: row, section: section)
    base.insertRows(at: [indexPath], with: animation)
  }
  
  public func reloadRow(at indexPath: IndexPath, with animation: UITableView.RowAnimation) {
    base.reloadRows(at: [indexPath], with: animation)
  }
  
  public func reloadRow(row: Int, in section: Int,with animation: UITableView.RowAnimation) {
    let indexPath = IndexPath(row: row, section: section)
    base.insertRows(at: [indexPath], with: animation)
  }
  
  public func deleteRow(at indexPath: IndexPath, with animation: UITableView.RowAnimation) {
    base.deleteRows(at: [indexPath], with: animation)
  }
  
  public func deleteRow(row: Int, in section: Int,with animation: UITableView.RowAnimation) {
    let indexPath = IndexPath(row: row, section: section)
    base.deleteRows(at: [indexPath], with: animation)
  }
  
  
  public func insert(section: Int, with animation: UITableView.RowAnimation) {
    let set = IndexSet(integer: section)
    base.insertSections(set, with: animation)
  }
  
  
  public func delete(section: Int, with animation: UITableView.RowAnimation) {
    let set = IndexSet(integer: section)
    base.deleteSections(set, with: animation)
  }
  
  
  public func reload(section: Int, with animation: UITableView.RowAnimation) {
    let set = IndexSet(integer: section)
    base.reloadSections(set, with: animation)
  }
  
  public func clearSelectedRows(animated: Bool) {
    base.indexPathsForSelectedRows?.forEach({ (indexPath) in
      base.deselectRow(at: indexPath, animated: animated)
    })
  }
  
}
