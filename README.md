<p align="center">
  <img src="/Benson/Assets.xcassets/AppIcon.appiconset/Icon-App-iTunes.png" alt="YourPerfectDay Logo" width="200" style="border-radius: 50%;">
  <h1 align="center">YourPerfectDay</h1>
</p>


<!-- 
<p align="center">
  <i>The energy, wellbeing, fitness, and health tracking app I've always wanted.</i>
</p> -->

![YPD Entry Screen](/Design/YPD%20App%20Entry%20Screen%20Mockup.jpg)


## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Personal Journey](#personal-journey)
- [Outcome](#outcome)
- [Development](#development)

## Introduction
![YourPerfectDay Screens](/Design/YPD%20Screen%20Designs/YPD%20-%20Conceptual%20Design.jpg)

Struggling with chronic fatigue symptoms and seeking to understand my own biology, "YourPerfectDay" was born. This iOS app consolidates all the biometric and quantified health data, everything from sleep to caloric intake, energy expenditure, and mood.

## Features

YourPerfectDay features include:

- **Data Consolidation**: Aggregating various health data for a comprehensive overview of one's wellbeing.
- **Real-time Analysis**: Sending the data to an external server for statistical analysis and correlation identification, powered by Python and libraries such as Pandas.
- **Visual Reports**: All analysis and correlations are reported back and visualized in appealing ways on the app.
- **Daily Surveys**: The app prompts users for a short survey multiple times a day to gauge their Focus, Energy, and Mood on a scale of 1-5.

## Technologies Used

YourPerfectDay is built with SwiftUI, leverages Apple's HealthKit libraries for obtaining health data, and uses Python and various libraries for statistical analysis.

## Personal Journey

Plagued by symptoms of chronic fatigue between 2017-2020, I built YourPerfectDay to understand how lifestyle choices were impacting my health. The app became a crucial tool in my journey to health recovery.

## Outcome

The app revealed a connection between low heart rate events and episodes of fatigue, eventually leading to the diagnosis of an eating disorder. In the following months, I gradually recovered, culminating in completing a 10-mile Tough Mudder race in July 2021.

## Development

Though YourPerfectDay is no longer in active development, it served as a personal project to learn SwiftUI and statistical analysis. It remains a testament to the power of self-quantification in understanding and improving personal health.

```bash
git clone https://github.com/your-github-username/YourPerfectDay
cd YourPerfectDay
open -a Xcode YourPerfectDay.xcodeproj
