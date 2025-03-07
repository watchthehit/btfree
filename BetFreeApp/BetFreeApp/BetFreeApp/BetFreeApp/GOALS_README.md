# BetFreeApp Goals Feature

## Overview

The Goals feature in BetFreeApp helps users set and track goals for handling gambling urges. It provides a structured approach to recovery by letting users visualize their progress and celebrate achievements.

## Key Components

### GoalsView

The main view that displays all goal-related content, including:
- Active goals
- Goal suggestions
- Completed goals
- Goal completion celebration

### EnhancedUserGoal

A data model that represents each goal with properties like:
- Title and description
- Goal type (daily, weekly, monthly)
- Target number of urges to handle
- Start date and end date
- Completion status and date

### Goal Cards

Interactive cards for both active and completed goals that provide:
- Visual progress tracking
- Time remaining information
- Completion actions
- Visual feedback and animations

### EnhancedNewGoalView

A modal view for creating new goals with customizable:
- Title and description
- Goal type
- Target value
- Target date

## Usage

### Viewing Goals

1. Navigate to the "Goals" tab in the app
2. Active goals appear at the top
3. Suggested goals appear below (if you have fewer than 3 active goals)
4. Completed goals appear at the bottom

### Creating Goals

1. Tap the "+" button in the top-right corner of the Goals screen
2. Fill in the goal details:
   - Enter a title
   - Optionally add a description
   - Select a goal type (daily, weekly, monthly)
   - Set a target number of urges to handle
   - Set a target completion date
3. Tap "Create Goal" to add it to your active goals

### Using Goal Suggestions

The app provides pre-defined goal suggestions based on common recovery milestones:
- Daily Goal: Handle 5 urges today
- Weekly Goal: Handle 20 urges this week
- Monthly Goal: Handle 50 urges this month

Tap on any suggestion card to instantly add it to your active goals.

### Completing Goals

When you handle enough urges to meet your goal:
1. A "Complete" button appears on the goal card
2. Tap "Complete" to mark the goal as finished
3. A celebration animation appears
4. The goal moves to the "Completed Goals" section

### Editing Goals

1. Tap "Edit" in the top-left corner of the Goals screen
2. Reorder or delete goals as needed
3. Tap "Done" when finished

## Goal Progress Tracking

Goals progress automatically updates as you log urges in the app. The system:
- Counts urges handled since the goal was created
- Updates the progress bar in real-time
- Shows completion percentage
- Automatically marks goals as complete when the target is reached

## Implementation Notes

- Goals are stored in the EnhancedAppState and persist between app sessions
- Goals integrate with the BetFreeApp design system using BFDesignColors
- Animations and transitions provide a polished user experience
- Interactive feedback helps engage users with the recovery process

## Best Practices

- Set realistic goals that match your recovery stage
- Use a mix of short-term (daily) and longer-term (weekly/monthly) goals
- Celebrate completed goals to reinforce positive behavior
- Review your goal history to see your progress over time 