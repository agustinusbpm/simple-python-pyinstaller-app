FROM cdrx/pyinstaller-linux:python2
ARG BUILD_ID
ENV BUILD_ID=${BUILD_ID}
COPY ./$BUILD_ID/sources /src
WORKDIR /src
CMD ["pyinstaller","-F","add2vals.py"]