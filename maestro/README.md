# 🤖 Maestro E2E Test Automation for Notes App

Complete end-to-end test automation suite for the Flutter Notes application using Maestro.

## 📋 **Installation**

### Install Maestro CLI
```bash
curl -Ls "https://get.maestro.mobile.dev" | bash
```

### Verify Installation
```bash
maestro --version
```

## 🚀 **Running Tests**

### Run Single Test Flow
```bash
# Test app launch
maestro test maestro/flows/0_app_launch.yaml

# Test note creation
maestro test maestro/flows/2_create_note.yaml

# Test full regression
maestro test maestro/flows/99_full_regression.yaml
```

### Run All Tests
```bash
# Run all flows in sequence
maestro test maestro/flows/
```

### Run with Device Selection
```bash
# Run on specific device
maestro test --device "iPhone 15" maestro/flows/2_create_note.yaml

# Run on Android device
maestro test --device "Pixel 6" maestro/flows/99_full_regression.yaml
```

## 📱 **Test Coverage**

### ✅ **Core Flows (0-6)**
- **0_app_launch.yaml** - App initialization and splash screen
- **1_notes_list.yaml** - Notes list verification
- **2_create_note.yaml** - Complete note creation flow
- **3_edit_note.yaml** - Note editing functionality
- **4_delete_note.yaml** - Note deletion with confirmation
- **5_pin_note.yaml** - Pin/unpin functionality
- **6_favourite_note.yaml** - Favourite/unfavourite functionality

### ✅ **Filtering Flows (7-9)**
- **7_filter_all_notes.yaml** - All notes filter
- **8_filter_pinned.yaml** - Pinned notes filter
- **9_filter_favourites.yaml** - Favourites notes filter

### ✅ **Category Flows (10-15)**
- **10_subcategory_all.yaml** - ALL category filter
- **11_subcategory_work.yaml** - WORK category filter
- **12_subcategory_urgent.yaml** - URGENT category filter
- **13_subcategory_personal.yaml** - PERSONAL category filter
- **14_subcategory_peace.yaml** - PEACE category filter
- **15_subcategory_mood.yaml** - MOOD category filter

### ✅ **Search & Regression (16, 99)**
- **16_search_notes.yaml** - Search functionality
- **99_full_regression.yaml** - Complete app regression

## 🔧 **Configuration**

### App Configuration
Edit `maestro/config/app_config.yaml` to match your app package name:
```yaml
appId: com.example.notes_application
```

Find your package name in `android/app/build.gradle` → `applicationId`.

## 🎯 **Test Features**

### **Robust Element Selection**
- Uses `anyOf` for multiple element selection strategies
- Handles both text and ID-based selection
- Graceful fallbacks for UI variations

### **Conditional Flows**
- `runFlow` with `when` conditions for adaptive testing
- Handles different UI patterns and states
- Robust error handling and recovery

### **Comprehensive Coverage**
- All CRUD operations tested
- All filtering and search features
- Edge cases and user flows
- Cross-platform compatibility

## 📊 **Test Reports**

### Generate Reports
```bash
# Run with HTML report
maestro test --report-html maestro/flows/99_full_regression.yaml

# Run with JSON report
maestro test --report-json maestro/flows/99_full_regression.yaml

# Run with video recording
maestro test --record maestro/flows/2_create_note.yaml
```

### View Reports
Reports are saved in the `maestro/reports/` directory.

## 🛠️ **Debugging**

### Debug Mode
```bash
# Run with verbose output
maestro test --verbose maestro/flows/2_create_note.yaml

# Run with debug pauses
maestro test --debug maestro/flows/2_create_note.yaml
```

### Common Issues
1. **Element not found**: Check semantic keys in Flutter widgets
2. **Timing issues**: Add `waitForAnimationToEnd` commands
3. **App ID mismatch**: Verify package name in app_config.yaml

## 🔑 **Required Semantic Keys**

Add these Keys to your Flutter widgets for reliable testing:

```dart
// Main navigation
Key('fab_create_note')
Key('hamburger_menu')
Key('search_button')

// Note elements
Key('note_title_field')
Key('note_body_field')
Key('save_note_button')
Key('pin_button')
Key('favourite_button')

// Category chips
Key('chip_all')
Key('chip_work')
Key('chip_urgent')
Key('chip_personal')
Key('chip_peace')
Key('chip_mood')

// Menu items
Key('menu_all_notes')
Key('menu_pinned')
Key('menu_favourites')
```

## 🚀 **CI/CD Integration**

### GitHub Actions
```yaml
- name: Run E2E Tests
  run: |
    maestro test maestro/flows/99_full_regression.yaml
```

### Fastlane
```ruby
desc "Run E2E tests"
lane :e2e_tests do
  maestro_test(
    flow: "maestro/flows/99_full_regression.yaml"
  )
end
```

## 📈 **Best Practices**

1. **Run tests before each release**
2. **Use semantic keys consistently**
3. **Keep flows independent and reusable**
4. **Update tests when UI changes**
5. **Use conditional flows for adaptive testing**

## 🎉 **Ready to Test!**

Your Flutter Notes app now has comprehensive E2E test coverage with Maestro! 🚀

Run the full regression suite to verify all functionality:
```bash
maestro test maestro/flows/99_full_regression.yaml
```
