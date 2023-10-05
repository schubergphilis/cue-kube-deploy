bundle: {
	_env:       "none"   @timoni(runtime:string:ENV)
	_tag:       "latest" @timoni(runtime:string:GITHUB_REF_NAME)
	apiVersion: "v1alpha1"
	name:       "demo-app"
	instances: {
		if _env == "dev" {
			redis: {
				module: {
					url:     "oci://ghcr.io/stefanprodan/modules/redis"
					version: "7.2.1"
				}
				namespace: "test"
				values: maxmemory: 256
			}
		}
		deployment: {
			module: url:     "oci://ghcr.io/schubergphilis/cue-modules/deploy"
			module: version: _tag
			namespace: "test"
			values: {
				image: {
					repository: "nginx"
					digest:     "sha256:d2b0e52d7c2e5dd9fe5266b163e14d41ed97fd380deb55a36ff17efd145549cd"
					tag:        "1.25.1"
				}
			}
		}
	}
}
