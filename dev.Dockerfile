# stage1 - build react app first 
FROM node:10 as build
WORKDIR /whist-client
COPY . ./
# install and cache orayya-frontend dependencies
RUN npm install
RUN npm audit fix

# RUN CI=true npm test
# build orayya-frontend
RUN npm run build

# stage 2 - build the final image and copy the react build files
FROM nginx:1.17.8-alpine
COPY --from=build /trending-bay-client/build/ /usr/share/nginx/html
# COPY --from=build /trending-bay-client/orayya_com_bundle.crt /etc/nginx/certs/orayya_com_bundle.crt
# COPY --from=build /trending-bay-client/orayya_com.key /etc/ssl/private/orayya_com.key
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d
# COPY custom-50x.html /usr/share/nginx/html/custom-50x.html
# COPY sitemap.xml /usr/share/nginx/html/sitemap.xml
# COPY logo.png /usr/share/nginx/html/logo.png
# COPY undraw_QA_engineers_dg5p.png /usr/share/nginx/html/undraw_QA_engineers_dg5p.png
EXPOSE 80
EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]