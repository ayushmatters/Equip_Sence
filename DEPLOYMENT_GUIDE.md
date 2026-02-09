# 🚀 EquipSense Deployment Guide

Complete guide for deploying EquipSense to production using Netlify (frontend) and Render (backend) with SQLite database.

---

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Deployment Architecture](#deployment-architecture)
- [Backend Deployment (Render)](#backend-deployment-render)
- [Frontend Deployment (Netlify)](#frontend-deployment-netlify)
- [Environment Variables](#environment-variables)
- [Post-Deployment Setup](#post-deployment-setup)
- [Common Issues & Solutions](#common-issues--solutions)
- [Testing Your Deployment](#testing-your-deployment)

---

## 🎯 Prerequisites

Before deploying, ensure you have:

- ✅ GitHub account (for code repository)
- ✅ Netlify account (free tier available) - [Sign up](https://app.netlify.com/signup)
- ✅ Render account (free tier available) - [Sign up](https://dashboard.render.com/register)
- ✅ Git repository with your code pushed
- ✅ All dependencies listed in requirements.txt and package.json

---

## 🏗 Deployment Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                       PRODUCTION                             │
│                                                              │
│  ┌─────────────────┐          ┌──────────────────────────┐  │
│  │   Netlify       │          │      Render              │  │
│  │   (Frontend)    │──────────▶      (Backend)           │  │
│  │                 │   HTTPS  │                          │  │
│  │  React + Vite   │          │  Django + Gunicorn       │  │
│  │  Static Build   │          │  REST API                │  │
│  └─────────────────┘          │                          │  │
│                                │  ┌──────────────────┐    │  │
│                                │  │  SQLite Database │    │  │
│                                │  │  (db.sqlite3)    │    │  │
│                                │  └──────────────────┘    │  │
│                                └──────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## 🖥️ Backend Deployment (Render)

### Step 1: Prepare Backend for Deployment

1. **Ensure all dependencies are in requirements.txt:**

   ```bash
   cd backend
   pip freeze > requirements.txt
   ```

2. **Verify production dependencies are included:**
   - `gunicorn` - Production WSGI server
   - `whitenoise` - Static file serving

### Step 2: Create Render Web Service

1. **Go to Render Dashboard:**
   - Visit [https://dashboard.render.com/](https://dashboard.render.com/)
   - Click **"New +"** → **"Web Service"**

2. **Connect Your Repository:**
   - Connect your GitHub account
   - Select your EquipSense repository
   - Grant necessary permissions

3. **Configure Build Settings:**

   ```
   Name: equipsense-backend
   Region: Choose closest to your users (e.g., Oregon USA)
   Branch: main
   Root Directory: backend
   Runtime: Python 3
   Build Command: pip install -r requirements.txt && python manage.py migrate && python manage.py collectstatic --noinput
   Start Command: gunicorn equipment_backend.wsgi:application
   ```

4. **Select Plan:**
   - Choose **"Free"** plan for testing
   - Note: Free tier may spin down after inactivity

### Step 3: Configure Environment Variables

In Render Dashboard → Your Service → Environment:

**Required Variables:**

```bash
SECRET_KEY=your-strong-random-secret-key-here-use-django-secret-key-generator
DEBUG=False
ALLOWED_HOSTS=your-backend.onrender.com
DATABASE_URL=db.sqlite3
CORS_ALLOWED_ORIGINS=https://your-frontend.netlify.app
```

**Optional Variables (if using OAuth/OTP):**

```bash
GOOGLE_OAUTH_CLIENT_ID=your-client-id.apps.googleusercontent.com
GOOGLE_OAUTH_CLIENT_SECRET=your-client-secret
GOOGLE_OAUTH_REDIRECT_URI=https://your-frontend.netlify.app/auth/google/callback
OTP_SERVICE_URL=your-otp-service-url
```

**Generate Strong SECRET_KEY:**

```bash
python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
```

### Step 4: Deploy Backend

1. Click **"Create Web Service"**
2. Wait for deployment to complete (5-10 minutes)
3. Note your backend URL: `https://your-backend.onrender.com`

### Step 5: Verify Backend Deployment

Test the health check endpoint:

```bash
curl https://your-backend.onrender.com/health/
```

Expected response:

```json
{
  "status": "healthy",
  "message": "EquipSense Backend is running",
  "python_version": "3.11.x",
  "debug_mode": false
}
```

---

## 🌐 Frontend Deployment (Netlify)

### Step 1: Prepare Frontend for Deployment

1. **Create `.env` file in `frontend/` directory:**

   ```bash
   cd frontend
   cp .env.example .env
   ```

2. **Update `.env` with your Render backend URL:**

   ```env
   VITE_API_URL=https://your-backend.onrender.com/api
   ```

3. **Test local build:**
   ```bash
   npm run build
   ```

   - Ensure build completes without errors
   - Check `dist/` folder is created

### Step 2: Deploy to Netlify

#### Option A: Netlify CLI (Recommended)

1. **Install Netlify CLI:**

   ```bash
   npm install -g netlify-cli
   ```

2. **Login to Netlify:**

   ```bash
   netlify login
   ```

3. **Initialize site:**

   ```bash
   cd frontend
   netlify init
   ```

   - Select "Create & configure a new site"
   - Choose team
   - Enter site name: `equipsense` (or your preferred name)

4. **Deploy:**
   ```bash
   netlify deploy --prod
   ```

#### Option B: GitHub Integration (Easier)

1. **Go to Netlify Dashboard:**
   - Visit [https://app.netlify.com/](https://app.netlify.com/)
   - Click **"Add new site"** → **"Import an existing project"**

2. **Connect GitHub:**
   - Select your repository
   - Grant permissions

3. **Configure Build Settings:**

   ```
   Base directory: frontend
   Build command: npm run build
   Publish directory: frontend/dist
   ```

4. **Click "Deploy site"**

### Step 3: Configure Netlify Environment Variables

In Netlify Dashboard → Site Settings → Environment Variables:

**Add Variable:**

```
Key: VITE_API_URL
Value: https://your-backend.onrender.com/api
```

**Optional (if using OAuth):**

```
Key: VITE_GOOGLE_CLIENT_ID
Value: your-google-client-id.apps.googleusercontent.com
```

### Step 4: Redeploy Frontend

After adding environment variables:

- Go to **Deploys** tab
- Click **"Trigger deploy"** → **"Deploy site"**

### Step 5: Get Your Frontend URL

Your site will be available at:

```
https://your-site-name.netlify.app
```

You can customize this in **Site Settings** → **Domain Management**

---

## 🔑 Environment Variables

### Backend (.env in `backend/`)

```env
# Django Configuration
SECRET_KEY=your-strong-random-secret-key
DEBUG=False
ALLOWED_HOSTS=your-backend.onrender.com

# Database
DATABASE_URL=db.sqlite3

# CORS - Add your Netlify frontend URL
CORS_ALLOWED_ORIGINS=https://your-frontend.netlify.app

# JWT (Optional)
JWT_SECRET_KEY=your-jwt-secret-key

# Google OAuth (Optional)
GOOGLE_OAUTH_CLIENT_ID=your-client-id.apps.googleusercontent.com
GOOGLE_OAUTH_CLIENT_SECRET=your-client-secret
GOOGLE_OAUTH_REDIRECT_URI=https://your-frontend.netlify.app/auth/google/callback

# OTP Service (Optional)
OTP_SERVICE_URL=http://your-otp-service-url/api/otp/send
```

### Frontend (.env in `frontend/`)

```env
# API Configuration
VITE_API_URL=https://your-backend.onrender.com/api

# Google OAuth (Optional)
VITE_GOOGLE_CLIENT_ID=your-client-id.apps.googleusercontent.com

# OTP Service (Optional)
VITE_OTP_SERVICE_URL=http://your-otp-service-url/api/otp
```

---

## 🔧 Post-Deployment Setup

### 1. Create Django Superuser

Access Render Shell:

1. Go to Render Dashboard → Your Service
2. Click **"Shell"** tab
3. Run:
   ```bash
   python manage.py createsuperuser
   ```

### 2. Update CORS Settings

Update backend environment variable `CORS_ALLOWED_ORIGINS` with your actual Netlify URL:

```
CORS_ALLOWED_ORIGINS=https://your-actual-site.netlify.app,https://your-backend.onrender.com
```

### 3. Update Google OAuth Redirect URI

In Google Cloud Console:

1. Go to **APIs & Services** → **Credentials**
2. Edit your OAuth 2.0 Client ID
3. Add authorized redirect URI:
   ```
   https://your-frontend.netlify.app/auth/google/callback
   ```

### 4. Test All Features

Test critical functionality:

- ✅ User registration
- ✅ User login
- ✅ CSV file upload
- ✅ Data visualization
- ✅ PDF report generation
- ✅ Admin dashboard access

---

## ⚠️ Common Issues & Solutions

### Issue 1: CORS Errors

**Symptom:** Frontend shows "CORS policy blocked" errors

**Solution:**

1. Verify `CORS_ALLOWED_ORIGINS` in backend includes your Netlify URL
2. Ensure no trailing slashes in URLs
3. Redeploy backend after updating environment variables

### Issue 2: 404 on Frontend Routes

**Symptom:** Refreshing page shows 404 error

**Solution:**
Add `_redirects` file in `frontend/public/`:

```
/*    /index.html   200
```

Then redeploy frontend.

### Issue 3: Backend Database Not Persisting

**Symptom:** Data disappears after backend restart

**Solution:**

- Render's free tier has ephemeral storage
- SQLite data persists between deploys but may be lost on service restarts
- For production, consider:
  - Upgrading to Render paid plan with persistent disk
  - Using PostgreSQL (Render provides free PostgreSQL)

### Issue 4: Static Files Not Loading

**Symptom:** Admin panel has no CSS styling

**Solution:**

1. Ensure `whitenoise` is in requirements.txt
2. Verify `STATIC_ROOT` is configured in settings.py
3. Build command includes `collectstatic`:
   ```bash
   python manage.py collectstatic --noinput
   ```

### Issue 5: Environment Variables Not Working

**Symptom:** App uses default values instead of env vars

**Solution:**

1. In Netlify: Environment variables must start with `VITE_`
2. In Render: After adding env vars, click **"Manual Deploy"**
3. Restart services after environment variable changes

### Issue 6: Render Service Spinning Down

**Symptom:** First request after inactivity is very slow

**Solution:**

- Free tier services spin down after 15 minutes of inactivity
- Consider:
  - Upgrading to paid plan
  - Using uptime monitoring service (e.g., UptimeRobot) to ping health endpoint

### Issue 7: Build Fails on Render

**Symptom:** Deployment fails during build

**Common Causes:**

1. **Missing dependencies:** Check requirements.txt is complete
2. **Python version mismatch:** Specify Python version in `runtime.txt`:
   ```
   python-3.11.0
   ```
3. **Migration errors:** Check database migrations are up to date

**Solution:**
Check build logs in Render dashboard for specific errors.

---

## 🧪 Testing Your Deployment

### 1. Health Check

```bash
curl https://your-backend.onrender.com/health/
```

### 2. API Endpoints

```bash
# Test authentication endpoint
curl https://your-backend.onrender.com/api/auth/register/ \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"username": "testuser", "email": "test@example.com", "password": "testpassword123"}'
```

### 3. Frontend Access

Visit `https://your-frontend.netlify.app` and test:

- Page loads correctly
- Can navigate between routes
- API calls work (check browser console for errors)

### 4. CORS Verification

Open browser DevTools → Network tab:

- Check API requests show correct origin headers
- Verify no CORS errors in console

---

## 📊 Production Checklist

Before going live, verify:

- [ ] `DEBUG=False` in backend environment variables
- [ ] Strong `SECRET_KEY` configured (not default)
- [ ] `ALLOWED_HOSTS` includes only your backend domain
- [ ] `CORS_ALLOWED_ORIGINS` includes only your frontend domain
- [ ] All environment variables set correctly
- [ ] Health check endpoint returns "healthy"
- [ ] Admin panel accessible and styled correctly
- [ ] User registration/login working
- [ ] CSV upload and processing working
- [ ] PDF generation working
- [ ] Google OAuth configured (if using)
- [ ] Database migrations applied
- [ ] Static files serving correctly
- [ ] No sensitive data in logs

---

## 🔒 Security Considerations

### Backend Security

1. **Never commit `.env` files** - Already in `.gitignore`
2. **Use strong SECRET_KEY** - Generate random 50+ character string
3. **Disable DEBUG in production** - Set `DEBUG=False`
4. **Whitelist CORS origins** - Don't use `*` wildcard
5. **Use HTTPS only** - Render and Netlify provide this automatically

### Frontend Security

1. **API keys in environment variables** - Never hardcode
2. **Validate user inputs** - Both frontend and backend
3. **Use HTTPS** - Netlify provides free SSL certificates

---

## 📚 Additional Resources

### Render Documentation

- [Python Deployment](https://render.com/docs/deploy-django)
- [Environment Variables](https://render.com/docs/environment-variables)
- [Persistent Storage](https://render.com/docs/disks)

### Netlify Documentation

- [Vite Deployment](https://docs.netlify.com/integrations/frameworks/vite/)
- [Environment Variables](https://docs.netlify.com/environment-variables/overview/)
- [Redirects & Rewrites](https://docs.netlify.com/routing/redirects/)

### Django Production

- [Deployment Checklist](https://docs.djangoproject.com/en/4.2/howto/deployment/checklist/)
- [WhiteNoise](http://whitenoise.evans.io/en/stable/)

---

## 🆘 Getting Help

If you encounter issues not covered here:

1. **Check service status:**
   - Render: https://status.render.com/
   - Netlify: https://www.netlifystatus.com/

2. **Review logs:**
   - Render: Dashboard → Your Service → Logs
   - Netlify: Dashboard → Deploys → Deploy log

3. **Common error patterns:**
   - 500 errors: Check backend logs for Python exceptions
   - 404 errors: Check routing and URL configuration
   - CORS errors: Verify environment variables

---

## 🎉 Success!

Once deployed, your EquipSense application will be accessible at:

- **Frontend:** `https://your-frontend.netlify.app`
- **Backend API:** `https://your-backend.onrender.com/api`
- **Admin Panel:** `https://your-backend.onrender.com/admin`
- **Health Check:** `https://your-backend.onrender.com/health/`

---

## 📝 Notes

### SQLite on Render Free Tier

**Important:** Render's free tier uses ephemeral storage. This means:

- ✅ Database persists between deployments
- ⚠️ Database may be reset if service is inactive for extended period
- ⚠️ Not suitable for production with important data

**For production use, consider:**

1. Upgrading to Render paid plan with persistent disk ($7/month)
2. Using Render's free PostgreSQL database instead of SQLite
3. Using external database service (e.g., MongoDB Atlas, PlanetScale)

### Free Tier Limitations

**Render Free Tier:**

- Services spin down after 15 minutes of inactivity
- First request after spin-down has ~30 second delay
- 750 hours/month limit (sufficient for 24/7 operation)

**Netlify Free Tier:**

- 100 GB bandwidth/month
- 300 build minutes/month
- Unlimited sites and deploys

---

**Made with ❤️ for EquipSense**

Last Updated: February 2026
