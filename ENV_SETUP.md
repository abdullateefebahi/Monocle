# Environment Setup Guide

## Setting up your Supabase credentials

This application uses environment variables to securely store sensitive API keys and configuration.

### Step 1: Get your Supabase credentials

1. Go to your Supabase project dashboard: https://app.supabase.com
2. Select your project (or create a new one)
3. Go to **Settings** → **API** in the sidebar
4. Copy the following values:
   - **Project URL** (e.g., `https://xxxxxxxxxxxxx.supabase.co`)
   - **anon/public key** (the `anon public` key)

### Step 2: Create your .env file

1. In the project root directory (`monocle_app/`), create a file named `.env` (without any extension)
2. Copy the content from `.env.example` to `.env`
3. Replace the placeholder values with your actual Supabase credentials:

```env
# Supabase Configuration
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your_actual_anon_key_here

# Optional: Go Backend API URL
GO_API_BASE_URL=http://localhost:8080
```

### Step 3: Verify the setup

Your `.env` file should look like this (with your actual values):

```env
SUPABASE_URL=https://abcdefghijklmnop.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiY2RlZmdoaWprbG1ub3AiLCJyb2xlIjoiYW5vbiIsImlhdCI6MTYzOTU4NDc5MSwiZXhwIjoxOTU1MTYwNzkxfQ.8YVjvUYqMQjM9YZ-example-key
GO_API_BASE_URL=http://localhost:8080
```

### Step 4: Run the app

```bash
flutter pub get
flutter run
```

## Important Security Notes

⚠️ **NEVER commit your `.env` file to version control!**

- The `.env` file is already added to `.gitignore`
- Only commit `.env.example` with placeholder values
- Share credentials securely through password managers or encrypted channels

## Troubleshooting

### Error: "Missing required environment variable"

- Make sure your `.env` file exists in the project root
- Verify the variable names match exactly: `SUPABASE_URL` and `SUPABASE_ANON_KEY`
- Check that there are no extra spaces or quotes around the values

### Error: "Unable to load asset: .env"

- Make sure `.env` is listed in `pubspec.yaml` under assets
- Run `flutter clean` and `flutter pub get`
- Restart your IDE

## Need Help?

If you're having issues:
1. Check that `.env` is in the correct location (project root)
2. Verify your Supabase credentials are correct
3. Make sure you've run `flutter pub get` after creating the file
