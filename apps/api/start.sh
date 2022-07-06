./wait-for-it.sh ${DATABASE_HOST:-timby_db}:${DATABASE_PORT:-3306} --strict --timeout=45  -- yarn run typeorm:migrate-prod
pm2-runtime start ./dist/main.js &