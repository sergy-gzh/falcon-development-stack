function FindProxyForURL(url, host) {
  if (shExpMatch(host, "*falcon.develop")) {
    return "PROXY 127.0.0.1:8666";
  }
  return "DIRECT";
}
