import SwiftUI

struct ShakeEffect: ViewModifier {
    var trigger: Bool
    var distance: CGFloat
    var animationDuration: Double
    var delayBetweenShakes: Double
    var initialDelay: Double

    @State private var currentStep: CGFloat = 0
    @State private var isAnimating = false

    func body(content: Content) -> some View {
        content
            .offset(x: currentStep) // Apply the offset dynamically
            .onChange(of: trigger) { _, newValue in
                if newValue && !isAnimating {
                    startShakeSequence()
                }
            }
    }

    private func startShakeSequence() {
        isAnimating = true

        // Start with an initial delay
        DispatchQueue.main.asyncAfter(deadline: .now() + initialDelay) {
            shakeAnimation(steps: [distance, -distance, 0])
        }
    }

    private func shakeAnimation(steps: [CGFloat]) {
        guard !steps.isEmpty else {
            isAnimating = false // Reset animating state when done
            return
        }

        withAnimation(.spring(response: animationDuration, dampingFraction: 0.1)) {
            currentStep = steps[0]
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration + delayBetweenShakes) {
            shakeAnimation(steps: Array(steps.dropFirst()))
        }
    }
}

extension View {
    func shakeEffect(
        trigger: Bool,
        distance: CGFloat = 30,
        animationDuration: Double = 0.4,
        delayBetweenShakes: Double = 0.1,
        initialDelay: Double = 0.25
    ) -> some View {
        self.modifier(ShakeEffect(
            trigger: trigger,
            distance: distance,
            animationDuration: animationDuration,
            delayBetweenShakes: delayBetweenShakes,
            initialDelay: initialDelay
        ))
    }
}
