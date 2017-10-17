{
    "application": {
        "name": "${projectName}",
        "version": "${version}",
        "package": "${packageName}",
        "author": "ymatescaffold",
        "createTime": "${.now?string("yyyy/MM/dd a HH:mm")}"
    },
    "security": {
        "enabled": false,
        "name": "",
        "prefix": "",
        "roles": {
            "admin": false,
            "operator": false,
            "user": false
        },
        "permissions": []
    },
    "apis": [
        {
            "name": "",
            "mapping": "",
            "type": "model",
            "model": "",
            "query": "",
            "description": "",
            "primary": {
                "label": "",
                "column": "",
                "name": "",
                "type": "string",
                "max": 0,
                "min": 0,
                "numeric": false,
                "description": ""
            },
            "params": [
                {
                    "label": "",
                    "name": "",
                    "column": "",
                    "type": "string",
                    "max": 0,
                    "min": 0,
                    "numeric": false,
                    "datetime": false,
                    "regex": "",
                    "required": true,
                    "filter": true,
                    "like": false,
                    "upload": {
                        "enabled": false,
                        "contentType": []
                    },
                    "description": ""
                }
            ]
        }
    ]
}
