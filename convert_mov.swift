import AVFoundation
import Foundation

let args = CommandLine.arguments
guard args.count == 3 else {
  fputs("Usage: swift convert_mov.swift input.mov output.mp4\n", stderr)
  exit(2)
}

let inputURL = URL(fileURLWithPath: args[1])
let outputURL = URL(fileURLWithPath: args[2])

try? FileManager.default.removeItem(at: outputURL)

let asset = AVURLAsset(url: inputURL)
let semaphore = DispatchSemaphore(value: 0)

guard let export = AVAssetExportSession(asset: asset, presetName: AVAssetExportPreset1280x720) ?? AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {
  fputs("Could not create export session\n", stderr)
  exit(1)
}

export.outputURL = outputURL
export.outputFileType = .mp4
export.shouldOptimizeForNetworkUse = true

export.exportAsynchronously {
  semaphore.signal()
}

semaphore.wait()

switch export.status {
case .completed:
  print("Converted: \(outputURL.path)")
case .failed, .cancelled:
  fputs("Export failed: \(export.error?.localizedDescription ?? "Unknown error")\n", stderr)
  exit(1)
default:
  fputs("Export ended with status: \(export.status.rawValue)\n", stderr)
  exit(1)
}
