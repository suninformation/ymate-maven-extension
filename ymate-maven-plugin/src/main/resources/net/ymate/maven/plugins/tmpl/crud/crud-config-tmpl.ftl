{
    "application": {
        "name": "${projectName}",
        "version": "${version}",
        "package": "${packageName}",
        "author": "ymatescaffold",
        "createTime": "${.now?string("yyyy/MM/dd a HH:mm")}",
        "locked": false
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
    "intercept": {
        "before": [],
        "after": [],
        "around": [],
        "params": {}
    },
    "apis": [
        <#if apis??>${apis}<#else>{
            "name": "",
            "mapping": "",
            "type": "model",
            "model": "",
            "query": "",
            "description": "",
            "locked": false,
            "timestamp": false,
            "status": [
                {
                    "enabled": false,
                    "name": "delete",
                    "column": "is_deleted",
                    "type": "integer",
                    "value": "1",
                    "reason": false,
                    "description": ""
                },
                {
                    "enabled": false,
                    "name": "restore",
                    "column": "is_deleted",
                    "type": "integer",
                    "value": "0",
                    "reason": false,
                    "description": ""
                }
            ],
            "primary": {
                "name": "",
                "label": "",
                "column": "",
                "type": "string",
                "validation": {
                    "max": 0,
                    "min": 0,
                    "regex": "",
                    "numeric": false
                },
                "description": ""
            },
            "params": [
                {
                    "name": "",
                    "label": "",
                    "column": "",
                    "type": "string",
                    "required": false,
                    "defaultValue": "",
                    "validation": {
                        "max": 0,
                        "min": 0,
                        "regex": "",
                        "mobile": false,
                        "email": false,
                        "numeric": false,
                        "datetime": false
                    },
                    "filter": {
                        "enabled": false,
                        "like": false,
                        "region": false
                    },
                    "upload": {
                        "enabled": false,
                        "contentTypes": []
                    },
                    "description": ""
                }
            ]
        }</#if>
    ]
}
