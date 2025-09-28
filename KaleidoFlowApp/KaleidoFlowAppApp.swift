//
//  KaleidoFlowAppApp.swift
//  KaleidoFlowApp


import SwiftUI

@main
struct KaleidoFlowApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

// MARK: - Root
struct RootView: View {
    @State private var showDetail = false
    @Namespace private var hero

    var body: some View {
        ZStack {
            AnimatedBlobBackground()
                .ignoresSafeArea()

            if showDetail {
                DetailScreen(hero: hero, showDetail: $showDetail)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.9).combined(with: .opacity),
                        removal: .scale(scale: 1.1).combined(with: .opacity)
                    ))
            } else {
                HomeScreen(hero: hero, showDetail: $showDetail)
                    .transition(.asymmetric(
                        insertion: .opacity,
                        removal: .scale(scale: 0.9).combined(with: .opacity)
                    ))
            }
        }
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showDetail)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Screen 1: Home
struct HomeScreen: View {
    let hero: Namespace.ID
    @Binding var showDetail: Bool
    @State private var tilt: CGSize = .zero
    @State private var pulse = false

    var body: some View {
        VStack(spacing: 28) {
            // Title
            VStack(spacing: 8) {
                Text("KaleidoFlow")
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .kerning(0.5)
                    .foregroundStyle(LinearGradient(colors: [.white, .white.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .shadow(radius: 20)
                Text("SwiftUI • Motion • Micro‑UX")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding(.top, 30)

            // Hero Card
            ZStack {
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        // subtle lines
                        VStack(spacing: 0) {
                            ForEach(0..<6) { i in
                                LinearGradient(
                                    colors: [Color.white.opacity(0.08), .clear],
                                    startPoint: .leading, endPoint: .trailing)
                                .frame(height: 1)
                                .padding(.vertical, 12)
                                .offset(y: CGFloat(i) * 8)
                            }
                        }
                        .mask(RoundedRectangle(cornerRadius: 32, style: .continuous))
                    )
                    .overlay(
                        // glow ring
                        Circle()
                            .stroke(AngularGradient(gradient: Gradient(colors: [.cyan, .purple, .pink, .blue, .cyan]), center: .center), lineWidth: 3)
                            .blur(radius: 10)
                            .opacity(0.8)
                            .scaleEffect(1.2)
                            .blendMode(.plusLighter)
                            .offset(x: 120, y: -90)
                    )
                    .overlay(
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "sparkles")
                                Text("Showcase Card")
                                Spacer()
                                TagView(text: "2025")
                            }
                            .font(.subheadline.bold())
                            .foregroundStyle(.white.opacity(0.8))

                            Text("Colorful, animated, glassy.")
                                .font(.title).bold()
                                .foregroundStyle(.white)

                            Text("Tap to open a delightful transition with matched geometry, parallax tilt, and custom particles.")
                                .font(.callout)
                                .foregroundStyle(.white.opacity(0.7))
                                .fixedSize(horizontal: false, vertical: true)

                            Spacer(minLength: 0)

                            HStack(spacing: 12) {
                                CapsuleButton(title: "Open Detail", systemImage: "arrow.right") {
                                    LightHaptics.play(.medium)
                                    showDetail = true
                                }
                                .matchedGeometryEffect(id: "cta", in: hero)

                                CapsuleButton(title: "Pulse", systemImage: "waveform") {
                                    withAnimation(.easeInOut(duration: 0.8).repeatCount(1, autoreverses: true)) {
                                        pulse.toggle()
                                    }
                                }
                            }
                        }
                        .padding(24)
                    )
                    .overlay(
                        // decorative floating circles that pulse
                        ZStack {
                            Circle().fill(Color.cyan.opacity(0.25))
                                .frame(width: pulse ? 60 : 40, height: pulse ? 60 : 40)
                                .blur(radius: 12)
                                .offset(x: -100, y: -60)
                            Circle().fill(Color.pink.opacity(0.25))
                                .frame(width: pulse ? 52 : 36, height: pulse ? 52 : 36)
                                .blur(radius: 14)
                                .offset(x: 90, y: 70)
                        }
                    )
                    .rotation3DEffect(.degrees(tilt.width / 8), axis: (x: 0, y: 1, z: 0))
                    .rotation3DEffect(.degrees(-tilt.height / 8), axis: (x: 1, y: 0, z: 0))
                    .shadow(color: .black.opacity(0.4), radius: 30, x: 0, y: 20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 32, style: .continuous)
                            .stroke(.white.opacity(0.08), lineWidth: 1)
                    )
                    .frame(height: 280)
                    .matchedGeometryEffect(id: "card", in: hero)
            }
            .padding(.horizontal, 24)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            tilt = value.translation
                        }
                    }
                    .onEnded { _ in
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            tilt = .zero
                        }
                    }
            )

            // Little footer
            Text("Two screens • No packages • Built for CV reels")
                .font(.footnote)
                .foregroundStyle(.white.opacity(0.6))
                .padding(.bottom, 20)
        }
        .padding(.bottom, 16)
    }
}

// MARK: - Screen 2: Detail
struct DetailScreen: View {
    let hero: Namespace.ID
    @Binding var showDetail: Bool
    @State private var progress: CGFloat = 0.72
    @State private var showStars = false

    var body: some View {
        VStack(spacing: 18) {
            HStack {
                Button(action: {
                    LightHaptics.play(.light)
                    showDetail = false
                }) {
                    Image(systemName: "chevron.left")
                        .font(.headline.weight(.bold))
                        .padding(10)
                        .background(.ultraThinMaterial, in: Circle())
                }

                Spacer()

                TagView(text: "SwiftUI")
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            // Matched card expands into header
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        LinearGradient(colors: [.clear, .white.opacity(0.08)], startPoint: .top, endPoint: .bottom)
                    )
                    .overlay(
                        // Ring progress centerpiece
                        VStack {
                            AnimatedRing(progress: progress)
                                .frame(width: 160, height: 160)
                                .padding(.top, 20)

                            Text("Design Polish")
                                .font(.title2.weight(.bold))
                                .padding(.top, 8)

                            Text("Micro‑interactions, depth, motion.")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.7))
                        }
                    )
                    .overlay(alignment: .topTrailing) {
                        Button {
                            LightHaptics.play(.heavy)
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                showStars.toggle()
                            }
                        } label: {
                            Image(systemName: showStars ? "sparkles" : "sparkles.square.filled.on.square")
                                .font(.title3)
                                .padding(10)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(16)
                    }
                    .matchedGeometryEffect(id: "card", in: hero)
                    .frame(height: 320)
                    .padding(.horizontal, 20)

                if showStars {
                    ParticleSpray()
                        .allowsHitTesting(false)
                        .padding(.horizontal, 20)
                        .frame(height: 320)
                }
            }

            VStack(alignment: .leading, spacing: 14) {
                Text("Highlights")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.9))

                FeatureRow(icon: "wand.and.rays", title: "Matched Geometry Hero", subtitle: "Smooth card→detail morph for delightful navigation.")
                FeatureRow(icon: "square.stack.3d.forward.dottedline", title: "3D Tilt & Parallax", subtitle: "Drag to tilt the glass card with depth.")
                FeatureRow(icon: "sparkles", title: "Particles & Rings", subtitle: "Custom Canvas particles and animated progress.")
                FeatureRow(icon: "circle.hexagonpath", title: "Generative Background", subtitle: "Blobby gradient canvas, 60 fps on modern devices.")

                HStack(spacing: 12) {
                    CapsuleButton(title: "Showcase CTA", systemImage: "hand.thumbsup.fill") {}
                        .matchedGeometryEffect(id: "cta", in: hero)

                    CapsuleButton(title: "Animate Ring", systemImage: "play.fill") {
                        withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                            progress = progress < 0.95 ? 1.0 : 0.42
                        }
                        LightHaptics.play(.rigid)
                    }
                }
                .padding(.top, 8)
            }
            .padding(20)

            Spacer()
        }
    }
}

// MARK: - Components
struct TagView: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.caption.bold())
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(LinearGradient(colors: [.purple.opacity(0.5), .blue.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(.white.opacity(0.15), lineWidth: 1)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(.white.opacity(0.4).gradient, lineWidth: 0.5)
                    .blendMode(.plusLighter)
            )
            .foregroundStyle(.white)
    }
}

struct CapsuleButton: View {
    var title: String
    var systemImage: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                Text(title)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(
                Capsule(style: .circular)
                    .fill(LinearGradient(colors: [.pink, .purple, .blue], startPoint: .leading, endPoint: .trailing))
            )
            .overlay(
                Capsule().stroke(.white.opacity(0.25), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.25), radius: 14, x: 0, y: 10)
            .foregroundStyle(.white)
        }
        .buttonStyle(.plain)
    }
}

struct FeatureRow: View {
    var icon: String
    var title: String
    var subtitle: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .frame(width: 28, height: 28)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.subheadline.weight(.semibold))
                Text(subtitle).font(.footnote).foregroundStyle(.white.opacity(0.7))
            }
            Spacer()
        }
    }
}

// MARK: - Animated Background
struct AnimatedBlobBackground: View {
    @State private var t: CGFloat = 0

    var body: some View {
        TimelineView(.animation) { timeline in
            let now = timeline.date.timeIntervalSinceReferenceDate
            let speed = 0.6
            let time = CGFloat(now * speed)

            Canvas { ctx, size in
                // Gradient background
                let rect = CGRect(origin: .zero, size: size)
                ctx.fill(Path(rect), with: .linearGradient(
                    Gradient(colors: [Color.black, Color(red: 0.06, green: 0.05, blue: 0.12)]),
                    startPoint: CGPoint(x: 0, y: 0),
                    endPoint: CGPoint(x: size.width, y: size.height)
                ))

                // Moving blobs
                for i in 0..<4 {
                    let phase = time + CGFloat(i) * 1.3
                    let radius: CGFloat = i % 2 == 0 ? 280 : 200
                    let x = size.width * (0.5 + 0.35 * cos(phase / (0.9 + CGFloat(i) * 0.2)))
                    let y = size.height * (0.5 + 0.35 * sin(phase / (1.0 + CGFloat(i) * 0.15)))
                    let blob = Path(ellipseIn: CGRect(x: x - radius/2, y: y - radius/2, width: radius, height: radius))
                    let color: Color = [Color.cyan, Color.purple, Color.pink, Color.blue][i]
                    ctx.fill(blob, with: .radialGradient(Gradient(colors: [color.opacity(0.4), .clear]), center: CGPoint(x: x, y: y), startRadius: 10, endRadius: radius))
                    ctx.addFilter(.blur(radius: 40))
                }
            }
        }
    }
}

// MARK: - Animated Ring
struct AnimatedRing: View {
    var progress: CGFloat // 0...1

    var body: some View {
        ZStack {
            Circle()
                .stroke(.white.opacity(0.08), lineWidth: 14)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(AngularGradient(gradient: Gradient(colors: [.cyan, .purple, .pink, .blue, .cyan]), center: .center), style: StrokeStyle(lineWidth: 14, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .shadow(radius: 8)
                .animation(.spring(response: 0.8, dampingFraction: 0.8), value: progress)

            Text("\(Int(progress * 100))%")
                .font(.system(.title, design: .rounded).weight(.bold))
        }
        .padding(6)
        .background(.ultraThinMaterial, in: Circle())
        .overlay(Circle().stroke(.white.opacity(0.15), lineWidth: 1))
    }
}

// MARK: - Particles
struct Particle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var vx: CGFloat
    var vy: CGFloat
    var life: CGFloat
    var hue: Double
}

struct ParticleSpray: View {
    @State private var particles: [Particle] = []

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, size in
                // update / spawn
                if particles.isEmpty { spawn(size: size, count: 80) }
                update(size: size)

                for p in particles {
                    var rect = CGRect(x: p.x, y: p.y, width: 6, height: 6)
                    rect = rect.insetBy(dx: -2, dy: -2)
                    ctx.opacity = Double(p.life)
                    ctx.fill(Path(ellipseIn: rect), with: .color(Color(hue: p.hue, saturation: 0.9, brightness: 1.0, opacity: 0.9)))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func spawn(size: CGSize, count: Int) {
        let center = CGPoint(x: size.width - 60, y: 60)
        particles = (0..<count).map { _ in
            let angle = Double.random(in: 0..<(2 * .pi))
            let speed = Double.random(in: 40...140)
            let vx = CGFloat(cos(angle) * speed)
            let vy = CGFloat(sin(angle) * speed)
            return Particle(
                x: center.x, y: center.y,
                vx: vx, vy: vy,
                life: CGFloat.random(in: 0.5...1.0),
                hue: Double.random(in: 0.5...0.9)
            )
        }
    }

    private func update(size: CGSize) {
        let dt: CGFloat = 1.0 / 60.0
        let gravity: CGFloat = 60
        let drag: CGFloat = 0.98

        for i in particles.indices {
            particles[i].vx *= drag
            particles[i].vy = particles[i].vy * drag + gravity * dt
            particles[i].x += particles[i].vx * dt
            particles[i].y += particles[i].vy * dt
            particles[i].life -= 0.01
        }
        particles.removeAll { $0.life <= 0 }
    }
}

// MARK: - Haptics Helper
enum LightHaptics {
    case light, medium, heavy, rigid

    static func play(_ type: LightHaptics) {
        let generator: UIImpactFeedbackGenerator
        switch type {
        case .light: generator = UIImpactFeedbackGenerator(style: .light)
        case .medium: generator = UIImpactFeedbackGenerator(style: .medium)
        case .heavy: generator = UIImpactFeedbackGenerator(style: .heavy)
        case .rigid: generator = UIImpactFeedbackGenerator(style: .rigid)
        }
        generator.impactOccurred()
    }
}
