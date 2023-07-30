FROM cdrx/pyinstaller-linux:python2
WORKDIR /src
CMD ["pyinstaller","-F","add2vals.py"]