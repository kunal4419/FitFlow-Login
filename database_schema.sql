-- FitFlow Database Schema for Supabase
-- Run these SQL commands in your Supabase SQL Editor

-- Enable Row Level Security (RLS)
-- Tables will have RLS policies to ensure users can only access their own data

-- ============================================
-- Workout Sessions Table
-- ============================================
CREATE TABLE IF NOT EXISTS workout_sessions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  workout_type TEXT NOT NULL CHECK (workout_type IN ('push', 'pull', 'legs')),
  duration_seconds INTEGER NOT NULL,
  completed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE workout_sessions ENABLE ROW LEVEL SECURITY;

-- RLS Policies for workout_sessions
CREATE POLICY "Users can view own workout sessions"
  ON workout_sessions FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own workout sessions"
  ON workout_sessions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own workout sessions"
  ON workout_sessions FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own workout sessions"
  ON workout_sessions FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================
-- Exercise Logs Table
-- ============================================
CREATE TABLE IF NOT EXISTS exercise_logs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  session_id UUID REFERENCES workout_sessions(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  exercise_name TEXT NOT NULL,
  set_number INTEGER NOT NULL,
  reps INTEGER NOT NULL,
  weight DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE exercise_logs ENABLE ROW LEVEL SECURITY;

-- RLS Policies for exercise_logs
CREATE POLICY "Users can view own exercise logs"
  ON exercise_logs FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own exercise logs"
  ON exercise_logs FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own exercise logs"
  ON exercise_logs FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own exercise logs"
  ON exercise_logs FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================
-- Bodyweight Tracking Table (Optional - for future use)
-- ============================================
CREATE TABLE IF NOT EXISTS bodyweight_logs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  weight DECIMAL(5, 2) NOT NULL,
  logged_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE bodyweight_logs ENABLE ROW LEVEL SECURITY;

-- RLS Policies for bodyweight_logs
CREATE POLICY "Users can view own bodyweight logs"
  ON bodyweight_logs FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own bodyweight logs"
  ON bodyweight_logs FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own bodyweight logs"
  ON bodyweight_logs FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own bodyweight logs"
  ON bodyweight_logs FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================
-- Indexes for Performance
-- ============================================
CREATE INDEX IF NOT EXISTS idx_workout_sessions_user_id ON workout_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_workout_sessions_completed_at ON workout_sessions(completed_at DESC);
CREATE INDEX IF NOT EXISTS idx_workout_sessions_workout_type ON workout_sessions(workout_type);

CREATE INDEX IF NOT EXISTS idx_exercise_logs_user_id ON exercise_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_exercise_logs_session_id ON exercise_logs(session_id);
CREATE INDEX IF NOT EXISTS idx_exercise_logs_exercise_name ON exercise_logs(exercise_name);
CREATE INDEX IF NOT EXISTS idx_exercise_logs_created_at ON exercise_logs(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_bodyweight_logs_user_id ON bodyweight_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_bodyweight_logs_logged_at ON bodyweight_logs(logged_at DESC);

-- ============================================
-- Functions for Analytics (Optional)
-- ============================================


-- Function to calculate estimated 1RM
CREATE OR REPLACE FUNCTION calculate_1rm(weight DECIMAL, reps INTEGER)
RETURNS DECIMAL AS $$
  SELECT ROUND(weight * (1 + reps / 30.0), 2);
$$ LANGUAGE SQL IMMUTABLE;

-- ============================================
-- Sample Queries for Testing
-- ============================================

-- Get user's recent workouts
-- SELECT * FROM workout_sessions 
-- WHERE user_id = auth.uid() 
-- ORDER BY completed_at DESC 
-- LIMIT 10;

-- Get personal records for an exercise
-- SELECT exercise_name, MAX(weight) as max_weight, reps
-- FROM exercise_logs
-- WHERE user_id = auth.uid()
-- GROUP BY exercise_name, reps
-- ORDER BY exercise_name, max_weight DESC;

-- Get weekly volume progression
-- SELECT 
--   DATE_TRUNC('week', completed_at) as week,
--   workout_type,
--   SUM(total_volume) as total_volume
-- FROM workout_sessions
-- WHERE user_id = auth.uid()
-- GROUP BY week, workout_type
-- ORDER BY week DESC;
