FROM cdrx/pyinstaller-linux:python2
COPY sources /src
WORKDIR /src
# CMD ["pyinstaller","-F","add2vals.py"]