import SwiftUI

struct ChartsView: View {
    @State private var selectedPeriod = TimePeriod.week
    @State private var showingDetails = false
    @State private var animateCharts = false
    @State private var selectedDataPoint: DataPoint?
    
    enum TimePeriod: String, CaseIterable {
        case day = "Day"
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }
    
    private let sampleData: [DataPoint] = [
        DataPoint(label: "Mon", value: 120, color: .blue),
        DataPoint(label: "Tue", value: 85, color: .green),
        DataPoint(label: "Wed", value: 200, color: .orange),
        DataPoint(label: "Thu", value: 150, color: .red),
        DataPoint(label: "Fri", value: 300, color: .purple),
        DataPoint(label: "Sat", value: 180, color: .pink),
        DataPoint(label: "Sun", value: 90, color: .cyan)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                chartsPicker
                
                barChartSection
                
                lineChartSection
                
                pieChartSection
                
                statisticsSection
            }
            .padding()
        }
        .navigationTitle("Analytics")
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5)) {
                animateCharts = true
            }
        }
        .sheet(item: $selectedDataPoint) { dataPoint in
            DataPointDetailView(dataPoint: dataPoint)
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Total Users")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("1,125")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("+12.5%")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                    
                    Text("vs last \(selectedPeriod.rawValue.lowercased())")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            ProgressView(value: 0.75)
                .tint(.blue)
                .scaleEffect(y: 2)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var chartsPicker: some View {
        Picker("Time Period", selection: $selectedPeriod) {
            ForEach(TimePeriod.allCases, id: \.self) { period in
                Text(period.rawValue).tag(period)
            }
        }
        .pickerStyle(.segmented)
    }
    
    private var barChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("User Activity")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Details") {
                    showingDetails = true
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            
            BarChartView(data: sampleData, animated: animateCharts) { dataPoint in
                selectedDataPoint = dataPoint
            }
            .frame(height: 200)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var lineChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Trend Analysis")
                .font(.headline)
                .fontWeight(.semibold)
            
            LineChartView(data: sampleData, animated: animateCharts)
                .frame(height: 150)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var pieChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Distribution")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack {
                PieChartView(data: sampleData, animated: animateCharts)
                    .frame(width: 120, height: 120)
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(sampleData.prefix(4)) { dataPoint in
                        HStack {
                            Circle()
                                .fill(dataPoint.color)
                                .frame(width: 8, height: 8)
                            
                            Text(dataPoint.label)
                                .font(.caption)
                            
                            Spacer()
                            
                            Text("\(Int(dataPoint.value))")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                    }
                }
                .padding(.leading)
                
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var statisticsSection: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            StatisticCard(title: "Average", value: "158", subtitle: "users/day", color: .blue)
            StatisticCard(title: "Peak", value: "300", subtitle: "highest day", color: .green)
            StatisticCard(title: "Growth", value: "+12.5%", subtitle: "this period", color: .orange)
            StatisticCard(title: "Retention", value: "87%", subtitle: "7-day", color: .purple)
        }
    }
}

struct DataPoint: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
    let color: Color
}

struct BarChartView: View {
    let data: [DataPoint]
    let animated: Bool
    let onTap: (DataPoint) -> Void
    
    private let maxValue: Double
    
    init(data: [DataPoint], animated: Bool, onTap: @escaping (DataPoint) -> Void) {
        self.data = data
        self.animated = animated
        self.onTap = onTap
        self.maxValue = data.map(\.value).max() ?? 1
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(data) { dataPoint in
                VStack(spacing: 4) {
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(dataPoint.color)
                        .frame(height: animated ? CGFloat(dataPoint.value / maxValue) * 160 : 0)
                        .onTapGesture {
                            onTap(dataPoint)
                        }
                    
                    Text(dataPoint.label)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .animation(.easeInOut(duration: 1.0).delay(0.1), value: animated)
    }
}

struct LineChartView: View {
    let data: [DataPoint]
    let animated: Bool
    
    private let maxValue: Double
    
    init(data: [DataPoint], animated: Bool) {
        self.data = data
        self.animated = animated
        self.maxValue = data.map(\.value).max() ?? 1
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let stepX = width / CGFloat(data.count - 1)
            
            ZStack {
                // Grid lines
                ForEach(0..<5) { i in
                    let y = height * CGFloat(i) / 4
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: width, y: y))
                    }
                    .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                }
                
                // Line chart
                Path { path in
                    for (index, dataPoint) in data.enumerated() {
                        let x = CGFloat(index) * stepX
                        let y = height - (CGFloat(dataPoint.value / maxValue) * height)
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .trim(from: 0, to: animated ? 1 : 0)
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                .animation(.easeInOut(duration: 1.5), value: animated)
                
                // Data points
                ForEach(Array(data.enumerated()), id: \.element.id) { index, dataPoint in
                    let x = CGFloat(index) * stepX
                    let y = height - (CGFloat(dataPoint.value / maxValue) * height)
                    
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 6, height: 6)
                        .position(x: x, y: y)
                        .scaleEffect(animated ? 1 : 0)
                        .animation(.easeInOut(duration: 0.5).delay(Double(index) * 0.1), value: animated)
                }
            }
        }
    }
}

struct PieChartView: View {
    let data: [DataPoint]
    let animated: Bool
    
    private let total: Double
    
    init(data: [DataPoint], animated: Bool) {
        self.data = data
        self.animated = animated
        self.total = data.reduce(0) { $0 + $1.value }
    }
    
    var body: some View {
        ZStack {
            ForEach(Array(data.enumerated()), id: \.element.id) { index, dataPoint in
                let startAngle = startAngle(for: index)
                let endAngle = endAngle(for: index)
                
                Path { path in
                    path.move(to: CGPoint(x: 60, y: 60))
                    path.addArc(
                        center: CGPoint(x: 60, y: 60),
                        radius: 50,
                        startAngle: Angle(degrees: startAngle),
                        endAngle: Angle(degrees: animated ? endAngle : startAngle),
                        clockwise: false
                    )
                    path.closeSubpath()
                }
                .fill(dataPoint.color)
                .animation(.easeInOut(duration: 1.0).delay(Double(index) * 0.1), value: animated)
            }
        }
    }
    
    private func startAngle(for index: Int) -> Double {
        let previousData = Array(data.prefix(index))
        let previousTotal = previousData.reduce(0) { $0 + $1.value }
        return (previousTotal / total) * 360 - 90
    }
    
    private func endAngle(for index: Int) -> Double {
        let currentData = Array(data.prefix(index + 1))
        let currentTotal = currentData.reduce(0) { $0 + $1.value }
        return (currentTotal / total) * 360 - 90
    }
}

struct StatisticCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct DataPointDetailView: View {
    let dataPoint: DataPoint
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Circle()
                    .fill(dataPoint.color)
                    .frame(width: 100, height: 100)
                    .overlay {
                        Text(dataPoint.label)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                
                VStack(spacing: 16) {
                    Text("Value: \(Int(dataPoint.value))")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("This represents the user activity for \(dataPoint.label)")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Data Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        ChartsView()
    }
}