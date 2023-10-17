package templates

import (
	netv1 "k8s.io/api/networking/v1"
)

#Ingress: netv1.#Ingress & {
	_config:    #Config
	apiVersion: "networking.k8s.io/v1"
	kind:       "Ingress"
	metadata: {
		name:      _config.metadata.name
		namespace: _config.metadata.namespace
		labels:    _config.metadata.labels
		if _config.metadata.annotations != _|_ {
			annotations: _config.metadata.annotations
		}
	}
	spec: {
		rules: [{
			if _config.ingress.host != "" {
				host: _config.ingress.host
			}
			http: {
				paths: [
					for setup in _config.ingress.http {
						path: setup.path
						backend: {
							service: {
								name: _config.metadata.name
								port: number: setup.port
							}
						}
					},
				]
			}
		}]
	}
}
