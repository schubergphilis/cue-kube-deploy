@if(test)

package main

values: {
	image: {
		repository: "cgr.dev/chainguard/nginx"
		digest:     "sha256:d2b0e52d7c2e5dd9fe5266b163e14d41ed97fd380deb55a36ff17efd145549cd"
		tag:        "1.25.1"
	}
	livenessProbe: {
		httpGet: {
			path: "/healthz"
			port: "http"
		}
	}
	readinessProbe: {
		httpGet: {
			path: "/healthz"
			port: "http"
		}
	}
	ingress: {
		create: true
		http: [{
			path: "/test"
			port: 80
		}]
	}
}
