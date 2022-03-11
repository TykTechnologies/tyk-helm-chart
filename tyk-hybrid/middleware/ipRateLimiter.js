    // ---- A Middleware based IP Rate limiter -----
    var ipRateLimiter = new TykJS.TykMiddleware.NewMiddleware({});

    ipRateLimiter.NewProcessRequest(function(request) {
        // Get the IP address
        var thisIP = request.Headers["X-Real-Ip"][0];
    
        // Set auth header
        request.SetHeaders["x-tyk-authorization"] = thisIP;
    
        var keyDetails = {
            "allowance": 100,
            "rate": 100,
            "per": 1,
            "expires": 0,
            "quota_max": 100,
            "quota_renews": 1406121006,
            "quota_remaining": 100,
            "quota_renewal_rate": 60,
            "access_rights": {
                "ip-ratelimit-api": {
                    "api_name": "Test API",
                    "api_id": "ip-ratelimit-api",
                    "versions": [
                        "Default"
                    ]
                }
            },
            "org_id": "53ac07777cbb8c2d53000002"
        }
    
        TykSetKeyData(thisIP, JSON.stringify(keyDetails), 1)
    
        return ipRateLimiter.ReturnData(request);
    });
    
    // Ensure init with a post-declaration log message
    log("IP rate limiter JS initialised");