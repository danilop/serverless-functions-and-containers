FROM node:14
COPY app/app.js app/package.json  ./
COPY app/public ./public
RUN npm install
EXPOSE 3000
CMD [ "node", "app.js" ]
