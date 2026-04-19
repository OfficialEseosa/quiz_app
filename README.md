# Trivia Quiz App

A Flutter quiz app that fetches live trivia questions from the [Open Trivia Database](https://opentdb.com/) API.

## Features

- Fetches 10 random General Knowledge questions on each session
- Multiple-choice answer buttons with immediate correct/wrong feedback
- Score tracking and question progress counter
- Linear progress bar showing quiz completion
- Results screen with percentage score on completion
- Restart button to play again with fresh questions
- Error handling with retry for network failures
- HTML entity decoding for clean question text

## Project Structure

```
lib/
├── main.dart          — App entry point
├── question.dart      — Question data model and JSON parsing
├── api_service.dart   — HTTP GET and JSON deserialization
└── quiz_screen.dart   — StatefulWidget managing all UI and state
```

## Getting Started

1. Clone the repo
2. Run `flutter pub get`
3. Run `flutter run`

Requires Flutter 3.x and an internet connection to fetch questions.

## API

Questions are fetched from:
```
https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiple
```
