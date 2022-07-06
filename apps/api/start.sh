./wait-for-it.sh "${DATABASE_HOST:-project_db}":"${DATABASE_PORT:-3306}" --strict --timeout=45 -- npm run prisma:migrate-prod && npm run prisma:seed
pm2-runtime start ./dist/src/main.js
