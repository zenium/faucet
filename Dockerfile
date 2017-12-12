FROM faucet/faucet-python3

ENV APK="apk -q"
ENV BUILDDEPS="gcc python3-dev musl-dev"
ENV TESTDEPS="bitstring pytest setuptools wheel virtualenv"
ENV PIP3="pip3 -q --no-cache-dir install --upgrade"

COPY ./ /faucet-src/

RUN \
  $APK add -U git $BUILDDEPS && \
  $PIP3 pip && \
  $PIP3 $TESTDEPS && \
  $PIP3 -r /faucet-src/requirements.txt && \
  $PIP3 /faucet-src && \
  python3 -m pytest /faucet-src/tests/test_valve.py && \
  for i in $BUILDDEPS ; do $APK del $i ; done && \
  find / -name \*pyc -delete

VOLUME ["/etc/ryu/faucet/", "/var/log/ryu/faucet/", "/var/run/faucet/"]

EXPOSE 6653 9302

CMD ["ryu-manager", "faucet.faucet"]
