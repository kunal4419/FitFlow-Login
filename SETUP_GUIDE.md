# FitFlow Setup Guide

This guide will walk you through setting up FitFlow with Supabase for workout tracking, authentication, and analytics.

---

## Prerequisites

- Flutter SDK installed (version 3.10.7 or higher)
- A Supabase account (free tier works fine)
- Android Studio / Xcode for mobile development
- Git (optional, for version control)

---

## Step 1: Create a Supabase Project

1. **Sign up for Supabase**
   - Go to [https://supabase.com](https://supabase.com)
   - Click "Start your project"
   - Sign in with GitHub or email

2. **Create a new project**
   - Click "New Project"
   - Choose your organization
   - Enter a project name (e.g., "FitFlow")
   - Set a strong database password (save this!)
   - Select a region close to your users
   - Click "Create new project"
   - Wait ~2 minutes for setup to complete

3. **Get your project credentials**
   - Once the project is ready, go to **Settings** → **API**
   - Copy the following (you'll need these):
     - **Project URL** (looks like `https://xxxxx.supabase.co`)
     - **anon public** key (the public API key)

---

## Step 2: Run the Database Schema

1. **Open the SQL Editor**
   - In your Supabase project dashboard
   - Click **SQL Editor** in the left sidebar
   - Click "New Query"

2. **Execute the schema**
   - Open the `database_schema.sql` file from this project
   - Copy the entire contents
   - Paste into the Supabase SQL Editor
   - Click "Run" (or press Cmd/Ctrl + Enter)
   - You should see "Success. No rows returned"

3. **Verify tables were created**
   - Go to **Table Editor** in the left sidebar
   - You should see three tables:
     - `workout_sessions`
     - `exercise_logs`
     - `bodyweight_logs`

---

## Step 3: Enable Email Authentication

1. **Configure email provider**
   - Go to **Authentication** → **Providers** in Supabase
   - Find "Email" in the list
   - Make sure it's **enabled** (toggle on)

2. **Configure email settings** (optional but recommended)
   - Go to **Authentication** → **URL Configuration**
   - Set your site URL (for production): `https://yourdomain.com`
   - For development, the default is fine

3. **Email templates** (optional)
   - Go to **Authentication** → **Email Templates**
   - Customize signup confirmation, password reset emails if desired

---

## Step 4: Configure the Flutter App

### Option A: Using --dart-define (Recommended)

This is the most secure approach and works well for production builds.

1. **Run the app with credentials**
   ```bash
   flutter run \
     --dart-define=SUPABASE_URL=https://your-project.supabase.co \
     --dart-define=SUPABASE_ANON_KEY=your-anon-key-here
   ```

2. **For Android Studio / VS Code**
   - Create a run configuration
   - Add to "Additional run args":
     ```
     --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your-anon-key
     ```

3. **For release builds**
   ```bash
   flutter build apk \
     --dart-define=SUPABASE_URL=https://your-project.supabase.co \
     --dart-define=SUPABASE_ANON_KEY=your-anon-key-here
   ```

### Option B: Using Environment File (Development only)

**WARNING:** Do NOT commit `.env` files to version control!

1. **Create a `.env` file** (if you prefer local development)
   - This method is NOT implemented by default
   - You would need to add `flutter_dotenv` package
   - For security reasons, `--dart-define` is recommended instead

---

## Step 5: Install Dependencies

1. **Get Flutter packages**
   ```bash
   flutter pub get
   ```

2. **Verify dependencies installed**
   - Check that these packages are in your `pubspec.yaml`:
     - `supabase_flutter`
     - `provider`
     - `fl_chart`
     - `intl`

---

## Step 6: Run the App

1. **Start your emulator/device**
   - Android: Start an AVD or connect a physical device
   - iOS: Start an iOS simulator or connect an iPhone

2. **Run the app**
   ```bash
   flutter run \
     --dart-define=SUPABASE_URL=https://your-project.supabase.co \
     --dart-define=SUPABASE_ANON_KEY=your-anon-key-here
   ```

3. **Verify it works**
   - App should launch without configuration errors
   - You should see the home page
   - Try browsing workouts (this works WITHOUT login)

---

## Step 7: Test Authentication

1. **Sign up a test user**
   - Tap the menu (hamburger icon)
   - Tap "Sign In"
   - Tap "Don't have an account? Sign up"
   - Enter an email and password
   - Submit

2. **Check your email**
   - Supabase sends a confirmation email by default
   - Click the confirmation link
   - (For development, you can disable email confirmation in Supabase settings)

3. **Sign in**
   - Use the same credentials to sign in
   - You should now see "Signed In" in the drawer menu

---

## Step 8: Test Workout Tracking

1. **Start a workout**
   - Navigate to Push/Pull/Legs page
   - Tap "Start Workout"
   - You should see the Active Workout screen

2. **Log some sets**
   - Enter weight, reps, and RPE for exercises
   - Add/remove sets as needed
   - The rest timer and workout timer should work

3. **Save the workout**
   - Tap "Save Workout"
   - You should be redirected to History
   - Your workout should appear in the list

4. **Verify data in Supabase**
   - Go to Supabase **Table Editor**
   - Check `workout_sessions` table
   - Check `exercise_logs` table
   - Your data should be there with your user ID

---

## Step 9: Test Analytics Features

1. **View History**
   - Menu → History
   - See your workout sessions
   - Expand a session to see exercises and sets
   - Check PRs (Personal Records) section
   - Verify streak calculation

2. **View Progress Charts**
   - Menu → Progress
   - Select time range (7/30/90 days)
   - Check weekly volume chart
   - Select an exercise for strength progression
   - Verify chart renders correctly

3. **Log Bodyweight** (optional)
   - Menu → Bodyweight
   - Add a bodyweight entry
   - View the trend chart
   - Verify statistics are calculated

---

## Troubleshooting

### "Configuration Error" on app launch

**Problem:** App shows "SUPABASE_URL is not configured"

**Solution:**
- Make sure you're passing `--dart-define` flags when running
- Double-check the URL and key are correct
- Remove any extra spaces or quotes

### Authentication errors

**Problem:** "Invalid login credentials" or signup fails

**Solution:**
- Verify email provider is enabled in Supabase
- Check if email confirmation is required (disable for testing)
- Go to Supabase **Authentication** → **Users** to see if user was created
- Check Supabase logs for errors

### RLS Policy errors

**Problem:** "new row violates row-level security policy"

**Solution:**
- Make sure you ran the entire `database_schema.sql` file
- Verify RLS is enabled on all tables
- Check that policies exist in Supabase **Authentication** → **Policies**
- Make sure you're signed in when trying to create data

### Data not showing up

**Problem:** Workouts saved but don't appear in History

**Solution:**
- Check Supabase **Table Editor** to see if data exists
- Verify user_id matches your current user
- Check for JavaScript console errors in Supabase logs
- Make sure RLS policies allow SELECT for your user

### Build errors

**Problem:** Flutter build fails with package errors

**Solution:**
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

### Charts not rendering

**Problem:** Progress charts are blank or show errors

**Solution:**
- Make sure you have workout data in the selected time range
- For strength chart, select an exercise you've actually logged
- Check that `fl_chart` package is installed correctly

---

## Optional: Disable Email Confirmation (Development Only)

For faster testing during development:

1. Go to Supabase **Authentication** → **Providers**
2. Click on "Email"
3. Scroll to "Confirm email"
4. **Disable** this setting
5. Users can now sign in immediately without confirming email

**NOTE:** Re-enable this for production!

---

## Security Best Practices

1. **Never commit credentials**
   - Don't put `SUPABASE_URL` or `SUPABASE_ANON_KEY` in source code
   - Use `--dart-define` or environment variables
   - Add `.env` to `.gitignore` if using that approach

2. **Use Row Level Security (RLS)**
   - Already configured in `database_schema.sql`
   - Users can only access their own data
   - Don't disable RLS in production

3. **Secure your Supabase project**
   - Use a strong database password
   - Enable email confirmation for production
   - Consider enabling MFA (multi-factor authentication)
   - Monitor auth logs regularly

4. **API key security**
   - The `anon` key is safe to use in mobile apps
   - It only allows operations permitted by RLS policies
   - Never expose your `service_role` key in the app

---

## Running Tests

Run the analytics unit tests:

```bash
flutter test test/analytics_test.dart
```

Expected output: All tests should pass ✓

---

## Production Deployment

### Android

1. **Build release APK**
   ```bash
   flutter build apk --release \
     --dart-define=SUPABASE_URL=https://your-project.supabase.co \
     --dart-define=SUPABASE_ANON_KEY=your-anon-key
   ```

2. **Build app bundle** (for Play Store)
   ```bash
   flutter build appbundle --release \
     --dart-define=SUPABASE_URL=https://your-project.supabase.co \
     --dart-define=SUPABASE_ANON_KEY=your-anon-key
   ```

### iOS

1. **Build release IPA**
   ```bash
   flutter build ios --release \
     --dart-define=SUPABASE_URL=https://your-project.supabase.co \
     --dart-define=SUPABASE_ANON_KEY=your-anon-key
   ```

2. **Archive in Xcode** for App Store submission

---

## Support & Resources

- **Supabase Documentation:** [https://supabase.com/docs](https://supabase.com/docs)
- **Flutter Documentation:** [https://docs.flutter.dev](https://docs.flutter.dev)
- **supabase_flutter Package:** [https://pub.dev/packages/supabase_flutter](https://pub.dev/packages/supabase_flutter)

---

## What's Next?

Now that your app is set up:

1. **Customize the workout data** in `lib/data/exercise_data.dart`
2. **Add more exercises** or create custom workout templates
3. **Extend analytics** with more charts and insights
4. **Add social features** (share workouts, leaderboards, etc.)
5. **Implement workout programs** (periodization, deload weeks, etc.)
6. **Add nutrition tracking** (meals, macros, etc.)

Happy training! 💪
