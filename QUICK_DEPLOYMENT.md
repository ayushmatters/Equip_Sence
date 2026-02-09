# 🚀 EquipSense - Quick Deployment Reference

## 📦 What You Need

- GitHub repository with EquipSense code
- Netlify account (frontend hosting)
- Render account (backend hosting)
- 30 minutes of time

---

## 🎯 Deployment URLs

After deployment, you'll have:

```
Frontend:  https://your-site.netlify.app
Backend:   https://your-backend.onrender.com
API:       https://your-backend.onrender.com/api
Admin:     https://your-backend.onrender.com/admin
Health:    https://your-backend.onrender.com/health/
```

---

## ⚡ 5-Minute Backend Deployment (Render)

### 1. Create Service

```
Render Dashboard → New Web Service → Connect GitHub Repo
```

### 2. Configure

```
Name:           equipsense-backend
Root Directory: backend
Build Command:  pip install -r requirements.txt && python manage.py migrate --noinput && python manage.py collectstatic --noinput
Start Command:  gunicorn equipment_backend.wsgi:application
```

### 3. Environment Variables

```bash
SECRET_KEY=<generate-strong-50-char-key>
DEBUG=False
ALLOWED_HOSTS=your-backend.onrender.com
DATABASE_URL=db.sqlite3
CORS_ALLOWED_ORIGINS=https://your-frontend.netlify.app
```

### 4. Deploy & Test

```bash
# Wait for deployment...
curl https://your-backend.onrender.com/health/
# Should return: {"status": "healthy", "message": "EquipSense Backend is running"}
```

---

## ⚡ 5-Minute Frontend Deployment (Netlify)

### 1. Connect Repository

```
Netlify Dashboard → New Site → Import from Git → Select Repository
```

### 2. Configure

```
Base directory:   frontend
Build command:    npm run build
Publish directory: frontend/dist
```

### 3. Environment Variable

```
VITE_API_URL=https://your-backend.onrender.com/api
```

### 4. Deploy & Test

```
Visit: https://your-site.netlify.app
```

---

## 🔑 Essential Environment Variables

### Backend (Render)

| Variable               | Value                   | Required |
| ---------------------- | ----------------------- | -------- |
| `SECRET_KEY`           | Strong random 50+ chars | ✅ Yes   |
| `DEBUG`                | `False`                 | ✅ Yes   |
| `ALLOWED_HOSTS`        | Your Render domain      | ✅ Yes   |
| `DATABASE_URL`         | `db.sqlite3`            | ✅ Yes   |
| `CORS_ALLOWED_ORIGINS` | Your Netlify URL        | ✅ Yes   |

### Frontend (Netlify)

| Variable       | Value                        | Required |
| -------------- | ---------------------------- | -------- |
| `VITE_API_URL` | Your Render backend + `/api` | ✅ Yes   |

---

## ✅ Post-Deployment Checklist

```bash
# 1. Test health check
curl https://your-backend.onrender.com/health/

# 2. Access frontend
open https://your-site.netlify.app

# 3. Create superuser (in Render Shell)
python manage.py createsuperuser

# 4. Test login
# Visit frontend and try logging in

# 5. Test admin
open https://your-backend.onrender.com/admin/
```

---

## 🔧 Common Issues - Quick Fixes

### CORS Error

```
Error: "blocked by CORS policy"
Fix: Update backend CORS_ALLOWED_ORIGINS to include your Netlify URL
```

### 404 on Refresh

```
Error: Frontend shows 404 when refreshing
Fix: Ensure frontend/public/_redirects file exists with:
/*    /index.html   200
```

### Static Files Missing

```
Error: Admin panel has no CSS
Fix: Check build command includes collectstatic:
python manage.py collectstatic --noinput
```

### Database Not Persisting

```
Error: Data disappears after restart
Note: Render free tier has ephemeral storage
Fix: Consider paid plan or use PostgreSQL
```

---

## 📞 Quick Links

- **Full Guide:** [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
- **Checklist:** [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)
- **Changes:** [DEPLOYMENT_CHANGES.md](DEPLOYMENT_CHANGES.md)
- **Render Docs:** https://render.com/docs/deploy-django
- **Netlify Docs:** https://docs.netlify.com/integrations/frameworks/vite/

---

## 🎯 Success Criteria

Your deployment is successful when:

- ✅ Health check returns "healthy"
- ✅ Frontend loads without errors
- ✅ Login/Register works
- ✅ CSV upload works
- ✅ Admin panel accessible
- ✅ No CORS errors in console

---

## 🆘 Need Help?

1. Check [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) for detailed instructions
2. Review "Common Issues" section above
3. Check deployment logs:
   - Render: Dashboard → Service → Logs
   - Netlify: Dashboard → Deploys → Deploy log
4. Verify all environment variables are set correctly

---

**Generated:** February 9, 2026  
**Platform:** Netlify (Frontend) + Render (Backend) + SQLite (Database)
