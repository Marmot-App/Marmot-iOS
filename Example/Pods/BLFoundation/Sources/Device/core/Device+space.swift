//
//  BLFoundation
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

import Foundation

// MARK: - 物理空间
public extension Device {
  
  ///  磁盘空间
 public static let diskSpace = DiskSpace()
  
  /// 内存空间
 public static let memorySpace = MemorySpace()
  
  public struct DiskSpace {
    /// 磁盘剩余空间 byte
    public var free: Int { return attributesOfFileSystem[.systemFreeSize] as? Int ?? -1 }
    /// 磁盘空间总量 byte
    public var total: Int { return attributesOfFileSystem[.systemSize] as? Int ?? -1 }
    /// 磁盘空间使用量 byte
    public var used: Int {
      let value = total - free
      return value <= 0 ? -1 : value
    }
    
    private var attributesOfFileSystem: [FileAttributeKey: Any] {
      do {
        return try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
      }catch{
        return [:]
      }
    }
  }
  
  public struct MemorySpace {
    /// 获取当前设备可用内存 byte
    public var free: Int {
      var vmStats = vm_statistics_data_t()
      var infoCount = mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.stride / MemoryLayout<integer_t>.stride)
      let kernReturn: kern_return_t = withUnsafeMutableBytes(of: &vmStats) {
        let boundBuffer = $0.bindMemory(to: Int32.self)
        return host_statistics(mach_host_self(), HOST_VM_INFO, boundBuffer.baseAddress, &infoCount)
      }
      if (kernReturn != KERN_SUCCESS) { return -1 }
      return Int(vm_page_size) * Int(vmStats.free_count)
    }
    
    /// 获取当前任务所占用的内存 byte
    public var used: Int {
      var taskInfo = task_basic_info_data_t()
      var infoCount = mach_msg_type_number_t(MemoryLayout<task_basic_info_data_t>.stride / MemoryLayout<natural_t>.stride)
      let kernReturn: kern_return_t = withUnsafeMutableBytes(of: &taskInfo) {
        let boundBuffer = $0.bindMemory(to: Int32.self)
        return task_info(mach_task_self_, task_flavor_t(TASK_BASIC_INFO), boundBuffer.baseAddress, &infoCount)
      }
      if (kernReturn != KERN_SUCCESS) { return -1 }
      return Int(taskInfo.resident_size)
    }
  }
  
}
