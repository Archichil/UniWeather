# UniWeather

UniWeather is a modern, functional weather app built with Swift, inspired by Apple's clean and intuitive design principles. The app provides up-to-date weather information with a focus on simplicity, usability, and elegant visuals.


## Features
- 🌦️ **Real-time weather updates** for your location  
  *Includes air pollution, wind speed, humidity, and feels-like temperature*
- 🗺️ **Interactive map** with 15 weather characteristic layers
- 📅 **Hourly and weekly forecasts**
- 🤖 **AI Assistant** for personalized weather insights
- 📆 **Integration with system calendar** *(Holiday forecasts)*
- 🔎 **Search and save multiple cities**
- ⌚ **watchOS mini-app** for weather on your wrist _(Implemented, but not deployed)_
- 🧩 **Dynamic widgets** that auto-update with the latest info
- ✨ **Sleek, Apple-like user interface**
- 📱 **Responsive and easy-to-use design**

## Screenshots

<div align="center">

<table width="100%">
  <tr>
    <td align="center" width="25%"><b>Main Screen</b></td>
    <td align="center" width="25%"><b>Map</b></td>
    <td align="center" width="25%"><b>AI Assistant</b></td>
    <td align="center" width="25%"><b>Location Searcher</b></td>
  </tr>
  <tr>
    <td width="25%"><video src="https://github.com/user-attachments/assets/c43f3cbf-a8de-4f7f-8b5e-b430983240ed" controls="controls" style="max-width: 100%;"></video></td>
    <td width="25%"><video src="https://github.com/user-attachments/assets/5d90bbcb-b9a2-4264-af00-2f474942563a" controls="controls" style="max-width: 100%;"></video></td>
    <td width="25%"><video src="https://github.com/user-attachments/assets/e83460e9-a976-451c-94c6-b30e39cf8bfe" controls="controls" style="max-width: 100%;"></video></td>
    <td width="25%"><video src="https://github.com/user-attachments/assets/b876aeef-8165-4a93-b040-e9fcf4b23f73" controls="controls" style="max-width: 100%;"></video></td>
  </tr>
</table>

<br>

<table width="100%">
  <tr>
    <td align="center" width="33%"><b>Holiday Forecast</b></td>
    <td align="center" width="33%"><b>Widgets</b></td>
    <td align="center" width="33%"><b>Widgets</b></td>
  </tr>
  <tr>
    <td width="33%"><img src="https://github.com/user-attachments/assets/db19ed43-bf36-44b2-a5e3-a9f9ceaf9ec3" alt="holiday_forecast_feature" width="100%" /></td>
    <td width="33%"><img src="https://github.com/user-attachments/assets/c6e5c5c7-7389-479c-b1b4-8b97d6374524" alt="widgets_feature_1" width="100%" /></td>
    <td width="33%"><img src="https://github.com/user-attachments/assets/660e747a-2cfa-4b40-87dc-47b213bdfcdd" alt="widgets_feature_2" width="100%" /></td>
  </tr>
</table>

</div>

## Getting Started

> :warning: Code in this repo may be far from production quality and is not expected to be easy and welcoming to newcomers.
>
> Continue on your own risk! Help & ideas are always welcome!

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Archichil/UniWeather.git
   ```

2. **Open the project in Xcode.**

3. **Rename the files named Config_example.plist([`Config_example.plist (Main target)`](UniWeather/Config_Example.plist) [`Config_example.plist (Widgets)`](UniWeatherWidgets/Config_Example.plist))  to `Config.plist`.**

4. **Put your API keys in the `Config.plist`.**

5. **IMPORTANT! Choose your account to sign the app and add the app group!**

6. **Change the app group constant in the code [`UserDefaults+Shared.swift`](UniWeather/Domain/Extensions/UserDefaults+Shared.swift#L11) here.** 

7. **Build and run** on your simulator or device. (Simulator constraints some app functionality)

## Requirements

- iOS 17.0+ (Widgets + Intents on iOS 18+)
- Xcode 16+
- Swift 5.10

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or suggestions.

## License

This project is licensed under the Apache License 2.0. See the [LICENSE](LICENSE) file for details.

---

> Inspired by Apple's design, crafted for everyone.
