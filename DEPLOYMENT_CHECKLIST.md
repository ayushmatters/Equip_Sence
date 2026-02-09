# EquipSense Deployment Checklist

## Pre-Deployment Tasks

### Code Preparation

- [ ] All code committed to Git repository
- [ ] Repository pushed to GitHub
- [ ] No sensitive data in code (check .env files are gitignored)
- [ ] requirements.txt is up to date
- [ ] package.json has correct build scripts

### Local Testing

- [ ] Backend runs successfully: `python manage.py runserver`
- [ ] Frontend builds successfully: `npm run build`
- [ ] Database migrations complete: `python manage.py migrate`
- [ ] Static files collect: `python manage.py collectstatic`
- [ ] All tests pass (if applicable)

---

## Backend Deployment (Render)

### Account Setup

- [ ] Render account created
- [ ] GitHub repository connected to Render
- [ ] Payment method added (if using paid tier)

### Service Configuration

- [ ] Web service created
- [ ] Root directory set to `backend`
- [ ] Build command: `pip install -r requirements.txt && python manage.py migrate --noinput && python manage.py collectstatic --noinput`
- [ ] Start command: `gunicorn equipment_backend.wsgi:application`
- [ ] Python version specified (3.11+)

### Environment Variables

- [ ] `SECRET_KEY` - Strong random string
- [ ] `DEBUG` - Set to `False`
- [ ] `ALLOWED_HOSTS` - Your Render domain
- [ ] `DATABASE_URL` - `db.sqlite3`
- [ ] `CORS_ALLOWED_ORIGINS` - Your Netlify frontend URL
- [ ] `GOOGLE_OAUTH_CLIENT_ID` (if using OAuth)
- [ ] `GOOGLE_OAUTH_CLIENT_SECRET` (if using OAuth)
- [ ] `GOOGLE_OAUTH_REDIRECT_URI` (if using OAuth)
- [ ] `OTP_SERVICE_URL` (if using OTP service)

### Deployment Verification

- [ ] Service deployed successfully
- [ ] Health check endpoint works: `https://your-backend.onrender.com/health/`
- [ ] No errors in deployment logs
- [ ] Database migrations applied
- [ ] Static files serving correctly
- [ ] Admin panel accessible: `https://your-backend.onrender.com/admin/`

### Post-Deployment

- [ ] Superuser created via Render Shell
- [ ] Admin login works
- [ ] API endpoints responding correctly

---

## Frontend Deployment (Netlify)

### Account Setup

- [ ] Netlify account created
- [ ] GitHub repository connected
- [ ] Site name configured

### Build Configuration

- [ ] Base directory: `frontend`
- [ ] Build command: `npm run build`
- [ ] Publish directory: `dist`
- [ ] Node version: 18+

### Environment Variables

- [ ] `VITE_API_URL` - Your Render backend URL + `/api`
- [ ] `VITE_GOOGLE_CLIENT_ID` (if using OAuth)
- [ ] `VITE_OTP_SERVICE_URL` (if using OTP)

### Deployment Files

- [ ] `netlify.toml` present in root
- [ ] `_redirects` file in `frontend/public/`
- [ ] `.env.example` updated with production values

### Deployment Verification

- [ ] Site deployed successfully
- [ ] No build errors in logs
- [ ] All routes accessible (no 404 on refresh)
- [ ] API calls working (check browser console)
- [ ] No CORS errors

---

## Integration Testing

### Authentication

- [ ] User registration works
- [ ] User login works
- [ ] JWT tokens generated correctly
- [ ] Token refresh works
- [ ] Google OAuth works (if enabled)
- [ ] OTP verification works (if enabled)

### Core Functionality

- [ ] CSV file upload works
- [ ] File validation works
- [ ] Data visualization displays correctly
- [ ] Charts render properly
- [ ] PDF report generation works
- [ ] PDF download works

### Admin Dashboard

- [ ] Admin login successful
- [ ] User management works
- [ ] System statistics display correctly
- [ ] Dataset oversight functional

### Cross-Browser Testing

- [ ] Chrome/Edge - Working
- [ ] Firefox - Working
- [ ] Safari - Working
- [ ] Mobile browsers - Working

---

## Security Checklist

### Backend

- [ ] `DEBUG=False` in production
- [ ] Strong `SECRET_KEY` configured
- [ ] `ALLOWED_HOSTS` whitelist configured
- [ ] CORS origins restricted to frontend domain only
- [ ] No default/weak passwords
- [ ] HTTPS enforced (Render provides this)
- [ ] CSP headers configured
- [ ] No sensitive data in logs

### Frontend

- [ ] No API keys hardcoded in source
- [ ] All secrets in environment variables
- [ ] HTTPS enforced (Netlify provides this)
- [ ] No console.log with sensitive data in production builds

### Database

- [ ] Migrations applied correctly
- [ ] No default admin passwords
- [ ] Database file permissions correct (if using persistent storage)

---

## Performance Optimization

### Frontend

- [ ] Build output optimized (check dist/ size)
- [ ] Images compressed
- [ ] Code splitting enabled (Vite default)
- [ ] Lazy loading for routes (if applicable)

### Backend

- [ ] Static files cached (WhiteNoise handles this)
- [ ] Gunicorn worker count configured
- [ ] Database queries optimized
- [ ] Large file uploads limited in settings

---

## Monitoring & Maintenance

### Uptime Monitoring

- [ ] Health check endpoint monitored
- [ ] Uptime monitoring service configured (e.g., UptimeRobot)
- [ ] Alert notifications set up

### Logging

- [ ] Backend logs accessible in Render dashboard
- [ ] Frontend deploy logs accessible in Netlify
- [ ] Error tracking configured (optional)

### Backups

- [ ] Database backup strategy defined
- [ ] Render persistent disk configured (if needed)
- [ ] Repository backed up on GitHub

---

## Documentation

- [ ] Deployment guide reviewed
- [ ] Environment variables documented
- [ ] API endpoints documented
- [ ] Admin credentials stored securely
- [ ] Deployment URLs recorded

---

## Common Issues Verified

- [ ] CORS configured correctly (no errors)
- [ ] Frontend routing works (no 404 on refresh)
- [ ] Static files load correctly
- [ ] Database persists data correctly
- [ ] Service doesn't crash on startup
- [ ] Migrations run automatically on deploy

---

## Final Verification

### URLs Working

- [ ] Frontend: `https://your-site.netlify.app`
- [ ] Backend API: `https://your-backend.onrender.com/api`
- [ ] Admin: `https://your-backend.onrender.com/admin`
- [ ] Health: `https://your-backend.onrender.com/health/`

### Features Working

- [ ] Complete user registration flow
- [ ] Complete login flow
- [ ] Complete CSV upload and analysis flow
- [ ] Admin dashboard fully functional
- [ ] All pages load without errors

### Performance

- [ ] Page load time acceptable (<3s)
- [ ] API response time acceptable (<2s)
- [ ] No console errors on any page
- [ ] Mobile responsive design working

---

## Go-Live Checklist

- [ ] All above items completed
- [ ] Stakeholders informed of deployment
- [ ] Documentation shared with team
- [ ] Support contact information ready
- [ ] Rollback plan documented
- [ ] Monitoring in place

---

## Post-Launch

- [ ] Monitor error rates first 24 hours
- [ ] Check user feedback
- [ ] Verify database is persisting correctly
- [ ] Confirm email notifications working (if applicable)
- [ ] Update DNS if using custom domain
- [ ] Share URLs with users

---

**Status:** [ ] Ready for Deployment

**Deployed By:** ******\_\_\_******

**Date:** ******\_\_\_******

**URLs:**

- Frontend: ******\_\_\_******
- Backend: ******\_\_\_******

**Notes:**

---

---

---
