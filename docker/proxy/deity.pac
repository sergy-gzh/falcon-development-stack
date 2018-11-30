function FindProxyForURL(url, host) {
  if (shExpMatch(host, "*falcon.develop")) {
  
    if (shExpMatch(host, "https*")) {
        return "PROXY 127.0.0.1:8667";
    } else {
        return "PROXY 127.0.0.1:8666";
    }
  }
  return "DIRECT";
}
