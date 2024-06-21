//
//  BarcodeScanner.swift
//  Cortex
//
//  Created by Sravan Karuturi on 6/19/24.
//

import SwiftUI
import AVFoundation
import VisionKit

struct BarcodeScanner: View {
    
    @State private var captureSession: AVCaptureSession?
    @State private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    @State private var isScanning = false
    
    @State var recItems: [RecognizedItem] = []
    
    var body: some View {
        
        ZStack{
            
            VideoCaptureView(recItems: $recItems)
                .edgesIgnoringSafeArea(.all)
            
            BarcodeOverlay(captureSession: $captureSession)
                .ignoresSafeArea(.all)
            
            
            LazyVStack{
                ForEach($recItems) { item in
                    Text(item.id.uuidString)
                }
            }
            
            
            
        }.onAppear {
            startSession()
        }
        
    }
    
    private func startSession() {
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = .resizeAspectFill
            videoPreviewLayer?.frame = UIScreen.main.bounds
            
            captureSession?.startRunning()
            
        } catch {
            print(error)
        }
        
    }
}

struct BarcodeOverlay: View {
    
    @Binding var captureSession: AVCaptureSession?
    
    var body: some View {
        
        ZStack{
            
            Rectangle()
                .fill(Color.clear)
                .frame(width: 300, height: 200)
                .overlay {
                    Text("Scan Bar Code Here")
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                }
                .background(Color.black.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .onTapGesture {
                    self.captureSession?.startRunning()
                }
                .onAppear{
                    self.captureSession?.stopRunning()
                }
            
        }
        
    }
}

struct VideoCaptureView: UIViewControllerRepresentable {
    
    @Binding var recItems: [RecognizedItem]
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let vc = DataScannerViewController(recognizedDataTypes: [.barcode()])
        return vc
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        uiViewController.delegate = context.coordinator
        try? uiViewController.startScanning()
    }
    
    func makeCoordinator() -> Gel {
        Gel(recItems: $recItems)
    }
    
    class Gel : DataScannerViewControllerDelegate {
        
        @Binding var recItems: [RecognizedItem]
        
        init(recItems: Binding<[RecognizedItem]>) {
            self._recItems = recItems
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd: [RecognizedItem], allItems: [RecognizedItem]){
            recItems.append(contentsOf: didAdd)
            print("Added \(didAdd)")
        }
        
        
    }
    
}

#Preview {
    BarcodeScanner()
}
