# algeria-electricity-gas-bill-calculator
🇩🇿 A Flutter application for calculating electricity and gas bills in Algeria with PDF export functionality. Features include tiered pricing calculation, regional contributions, and professional bill generation.
# 🇩🇿 Algeria Electricity & Gas Bill Calculator

A modern Flutter application designed to help Algerian residents calculate their electricity and gas utility bills with accurate pricing tiers and regional contributions.

## ✨ Features

- **📊 Dual Utility Calculation**: Calculate both electricity (kWh) and gas (Therms) consumption
- **💰 Tiered Pricing System**: Accurate implementation of Algeria's progressive pricing structure
- **🗺️ Regional Support**: Automatic contribution calculation for North/South regions
- **📄 PDF Export**: Generate professional, printable bills with all calculation details
- **🎨 Modern UI**: Clean, intuitive interface with responsive design
- **🔢 Input Validation**: Comprehensive form validation for accurate calculations
- **📱 Cross-Platform**: Works on Android, iOS, and desktop platforms

## 🏗️ Architecture

- **Clean Architecture**: Separation of concerns with dedicated service classes
- **PDF Service**: Modular PDF generation with professional styling
- **Data Models**: Type-safe data transfer objects
- **Responsive Design**: Adaptive layout for different screen sizes
## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=2.17.0)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/algeria-electricity-gas-bill-calculator.git
```

2. Navigate to the project directory:
```bash
cd algeria-electricity-gas-bill-calculator
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the application:
```bash
flutter run
```

## 📦 Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  pdf: ^3.11.3           # PDF generation
  printing: ^5.14.2      # PDF preview and printing
```

## 🧮 Pricing Structure

### Electricity Rates (DA/kWh):
- **0-125 kWh**: 1.7787 DA
- **126-250 kWh**: 4.1789 DA  
- **251-1000 kWh**: 4.8120 DA
- **>1000 kWh**: 5.4796 DA

### Gas Rates (DA/Therm):
- **0-1125 Therms**: 0.1682 DA
- **1126-2500 Therms**: 0.3245 DA
- **2501-7500 Therms**: 0.4025 DA
- **>7500 Therms**: 0.4599 DA

### Tax Structure:
- **Low consumption**: 9% VAT
- **High consumption**: 19% VAT
- **Regional contribution**: 0.6445% (South regions only)

## 📱 Screenshots
| Main Calculator | Results Display |
|----------------|----------------|
| ![Calculator](/screenshots/secreenshot1.JPG) | ![Results](/screenshots/secreenshot2.JPG) |

| PDF Export Page 1 | PDF Export Page 2|
|----------------|----------------|
| ![Results](/screenshots/secreenshot3.JPG) | ![Results](/screenshots/secreenshot4.JPG) |

## 🗂️ Project Structure

```
lib/
├── main.dart              # Application entry point
├── HomePage.dart          # Main calculator UI
├── PdfService.dart       # PDF generation service
├── AboutPage.dart       # Short description about app
└── models/
    └── bill_data.dart     # Data model
```
## 🎯 Use Cases

- **📋 Personal Use**: Calculate monthly utility bills at home
- **🏢 Property Management**: Bulk calculations for multiple properties  
- **📊 Budget Planning**: Estimate future utility costs
- **🏘️ Community Tools**: Help neighbors understand their bills

## 🌟 Key Benefits

- **Accuracy**: Implements official Algerian utility pricing
- **Convenience**: No need for manual calculations
- **Professional Output**: Generate official-looking bills
- **Offline Capable**: Works without internet connection
- **Free & Open Source**: No hidden costs or subscriptions

## 🔧 Technical Features

- **State Management**: StatefulWidget with proper state handling
- **Form Validation**: Comprehensive input validation
- **PDF Generation**: Professional document creation with tables and styling
- **Responsive UI**: GridView layouts that adapt to screen sizes

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## 📞 Contact

- **Issues**: [GitHub Issues](https://github.com/GasbaouiMohammedAlAmin/algeria-electricity-gas-bill-calculator/issues)
- **Discussions**: [GitHub Discussions](https://github.com/GasbaouiMohammedAlAmin/algeria-electricity-gas-bill-calculator/discussions)

