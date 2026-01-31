# Supabase Database Schema Guide

## Overview

This schema creates a complete database structure for Project Monocle with gamification, communities, quests, and transactions.

## Tables

### 1. **profiles**
User profile information linked to Supabase Auth users.

**Key Fields:**
- `id`: References auth.users
- `username`: Unique username
- `display_name`, `avatar_url`, `bio`
- `phone_number`, `matriculation_number`: For verification
- `level`, `total_xp`: Gamification data
- `is_verified`, `is_onboarding_complete`: Status flags

### 2. **user_wallets**
User currency balances (renamed from `wallets`).

**Key Fields:**
- `spark_balance`: Soft currency (Sparks ⚡)
- `orb_balance`: Hard currency (Orbs 🔮)
- `lifetime_sparks_earned`, `lifetime_orbs_earned`: Total earned
- `last_daily_bonus_at`: Track daily login rewards

### 3. **transactions**
Immutable transaction ledger for all currency movements.

**Key Fields:**
- `type`: credit, debit, transfer, reward, purchase, refund
- `currency`: spark or orb
- `amount`, `balance_after`: Transaction details
- `reference_id`, `reference_type`: Link to quests, purchases, etc.
- `from_user_id`, `to_user_id`: For transfers

### 4. **community**
Community/group information (singular name as requested).

**Key Fields:**
- `name`, `slug`: Community identification
- `owner_id`: Community creator
- `sector_type`: tech, art, gaming, education, etc.
- `is_public`, `is_verified`, `is_archived`: Status flags
- `member_count`: Auto-updated via trigger
- `settings`: JSONB for flexible configuration

### 5. **community_members**
Membership relationships between users and communities.

**Key Fields:**
- `role`: owner, admin, moderator, member
- `is_active`, `is_muted`, `is_banned`: Member status
- `permissions`: JSONB for granular permissions
- `custom_nickname`: Per-community display name

### 6. **quests**
Quest/mission definitions.

**Key Fields:**
- `type`: daily, weekly, monthly, story, event, community, achievement
- `rarity`: common, uncommon, rare, epic, legendary
- `difficulty`: easy, medium, hard, expert
- `reward_sparks`, `reward_orbs`, `xp_reward`: Rewards
- `objectives`: JSONB array of quest objectives
- `community_id`: Optional community-specific quests
- `is_repeatable`, `cooldown_hours`: Repeatability settings

### 7. **user_quest_progress**
Tracks individual user progress on quests.

**Key Fields:**
- `status`: available, started, in_progress, completed, claimed, expired, abandoned
- `progress_percentage`: 0-100 completion indicator
- `objectives`: JSONB tracking individual objective progress
- `started_at`, `completed_at`, `claimed_at`: Timeline

### Additional Tables

- **daily_missions**: User-specific daily challenges
- **channels**: Community chat channels
- **messages**: Real-time messaging within channels

## How to Set Up

### Step 1: Access Supabase SQL Editor

1. Go to https://app.supabase.com
2. Select your project
3. Click on **SQL Editor** in the sidebar
4. Click **New Query**

### Step 2: Run the Schema

1. Copy the entire contents of `supabase_schema.sql`
2. Paste into the SQL Editor
3. Click **Run** or press `Ctrl/Cmd + Enter`

### Step 3: Verify Tables Created

Go to **Table Editor** in the sidebar and verify these tables exist:
- ✅ profiles
- ✅ user_wallets
- ✅ transactions
- ✅ community
- ✅ community_members
- ✅ quests
- ✅ user_quest_progress

## Key Features

### 🔒 Row Level Security (RLS)

All tables have RLS enabled with appropriate policies:
- Users can only view/edit their own data
- Public data is viewable by everyone
- Community members can access community content
- Service role has elevated permissions for backend operations

### 🔄 Automatic Triggers

1. **New User Signup**
   - Auto-creates profile
   - Initializes wallet with 100 Sparks welcome bonus
   - Records welcome transaction

2. **Community Member Count**
   - Auto-updates when members join/leave
   - Handles active/inactive status changes

3. **Quest Completion Tracking**
   - Auto-increments completion count when users complete quests
   - Tracks progress across all users

4. **Updated At Timestamps**
   - Auto-updates `updated_at` on profile, community, and quest changes

5. **Community Slug Generation**
   - Auto-generates unique URL-friendly slugs from community names

### 📊 Indexes

Optimized indexes for common queries:
- User lookups
- Transaction history
- Community searches
- Quest filtering
- Message pagination

### 🔴 Real-time Subscriptions

Enabled for:
- `user_wallets` - Live balance updates
- `transactions` - Live transaction feed
- `messages` - Real-time chat
- `user_quest_progress` - Live quest updates
- `community_members` - Member join/leave notifications

## Sample Data

The schema includes sample data:
- 5 starter quests (Story, Daily, Weekly, Achievement)
- 3 public communities
- Pre-configured with rewards and objectives

## Common Queries

### Get User Profile with Wallet
```sql
SELECT p.*, w.spark_balance, w.orb_balance, w.lifetime_sparks_earned
FROM profiles p
LEFT JOIN user_wallets w ON w.user_id = p.id
WHERE p.id = '<user_id>';
```

### Get Active Quests
```sql
SELECT * FROM quests
WHERE is_active = true
  AND (start_date IS NULL OR start_date <= NOW())
  AND (end_date IS NULL OR end_date >= NOW())
ORDER BY is_featured DESC, rarity DESC, created_at DESC;
```

### Get User's Quest Progress
```sql
SELECT q.*, uqp.status, uqp.progress_percentage, uqp.started_at
FROM quests q
INNER JOIN user_quest_progress uqp ON uqp.quest_id = q.id
WHERE uqp.user_id = '<user_id>'
ORDER BY uqp.started_at DESC;
```

### Get Community with Member Count
```sql
SELECT c.*, COUNT(cm.id) as actual_members
FROM community c
LEFT JOIN community_members cm ON cm.community_id = c.id AND cm.is_active = true
WHERE c.is_public = true AND c.is_archived = false
GROUP BY c.id
ORDER BY actual_members DESC;
```

### Get Transaction History
```sql
SELECT * FROM transactions
WHERE user_id = '<user_id>'
ORDER BY created_at DESC
LIMIT 50;
```

## Important Notes

⚠️ **Security**: The schema uses Service Role for sensitive operations (wallet updates, transaction creation). Never expose your service role key in client-side code!

✅ **Scalability**: Indexes are set up for optimal query performance. Add more as needed based on your query patterns.

🔄 **Migrations**: For production, create migrations instead of running the entire schema. Use Supabase Migrations or a migration tool.

## Troubleshooting

### "relation already exists" error
Some tables might already exist. You can either:
- Drop the existing tables first (⚠️ deletes all data)
- Use `CREATE TABLE IF NOT EXISTS` (already in schema)
- Comment out tables that already exist

### RLS Policy Issues
If users can't access data:
1. Check that RLS is enabled
2. Verify user is authenticated
3. Check policy conditions match your use case
4. Use Supabase logs to debug policy failures

### Trigger Not Firing
1. Ensure the function exists
2. Check function permissions (SECURITY DEFINER)
3. Verify trigger is attached to correct table/operation

## Next Steps

1. ✅ Run the schema in Supabase
2. 🔑 Update your `.env` file with Supabase credentials
3. 🧪 Test with sample data
4. 🚀 Start building your Flutter app!
