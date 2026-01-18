//
//  NutritionAssistantView.swift
//  Loop
//
//  Created for INSU Nutrition Assistant
//

import SwiftUI
import PhotosUI
import LoopUI

/// Main view for the Nutrition Assistant chat interface
struct NutritionAssistantView: View {
    @StateObject private var viewModel = NutritionAssistantViewModel()
    @State private var showingImageSourcePicker = false
    @State private var showingCamera = false
    @State private var showingPhotoLibrary = false

    private let onDismiss: () -> Void
    private let onCarbsSelected: (Double) -> Void

    init(onDismiss: @escaping () -> Void, onCarbsSelected: @escaping (Double) -> Void) {
        self.onDismiss = onDismiss
        self.onCarbsSelected = onCarbsSelected
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            NutritionAssistantHeader(onDismiss: onDismiss)

            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            ChatMessageView(
                                message: message,
                                onSuggestionTapped: { suggestion in
                                    onCarbsSelected(suggestion.estimatedCarbs)
                                },
                                onReceiptTapped: { totalCarbs in
                                    onCarbsSelected(totalCarbs)
                                }
                            )
                            .id(message.id)
                        }

                        if viewModel.isLoading {
                            HStack {
                                TypingIndicator()
                                Spacer()
                            }
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages.count) { _ in
                    scrollToBottom(proxy: proxy)
                }
                .onChange(of: viewModel.isLoading) { _ in
                    scrollToBottom(proxy: proxy)
                }
            }

            // Input area
            ChatInputView(
                text: $viewModel.inputText,
                isLoading: viewModel.isLoading,
                onSend: { viewModel.sendMessage() },
                onCamera: { showingImageSourcePicker = true }
            )
        }
        .background(Color.white)
        .confirmationDialog("Add Photo", isPresented: $showingImageSourcePicker, titleVisibility: .visible) {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button("Take Photo") {
                    showingCamera = true
                }
            }
            Button("Choose from Library") {
                showingPhotoLibrary = true
            }
            Button("Cancel", role: .cancel) {}
        }
        .fullScreenCover(isPresented: $showingCamera) {
            CameraView(sourceType: .camera) { image in
                if let image = image {
                    viewModel.analyzeImage(image)
                }
            }
            .ignoresSafeArea()
        }
        .sheet(isPresented: $showingPhotoLibrary) {
            PhotoLibraryPicker { image in
                if let image = image {
                    viewModel.analyzeImage(image)
                }
            }
        }
        .onAppear {
            viewModel.onCarbSuggestionSelected = onCarbsSelected
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        if let lastMessage = viewModel.messages.last {
            withAnimation(.easeOut(duration: 0.2)) {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
}
