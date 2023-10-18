package templates

import (
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
)

#Deployment: appsv1.#Deployment & {
	_config:    #Config
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		name:      _config.metadata.name
		namespace: _config.metadata.namespace
		labels:    _config.metadata.labels
		if _config.metadata.annotations != _|_ {
			annotations: _config.metadata.annotations
		}
	}
	spec: appsv1.#DeploymentSpec & {
		replicas: _config.replicas
		selector: matchLabels: _config.metadata.labelSelector
		template: {
			metadata: {
				labels: _config.metadata.labelSelector
				if _config.podAnnotations != _|_ {
					annotations: _config.podAnnotations
				}
			}
			spec: corev1.#PodSpec & {
				serviceAccountName: _config.metadata.name
				containers: [
					{
						name:  _config.metadata.name
						image: "\(_config.image.repository):\(_config.image.tag)"
						if _config.command != _|_ {command: _config.command}
						if _config.containerArgs != _|_ {args: _config.containerArgs}
						imagePullPolicy: _config.imagePullPolicy
						if _config.environmentVars != _|_ {
							env: [
								for var in _config.environmentVars {
									name:  var.name
									value: var.value
								},
							]
						}
						ports: [
							if _config.ports != _|_ {
								for port in _config.ports {
									name:          port.name
									containerPort: port.containerPort
									protocol:      port.protocol
								}
							}, // else
							{
								name:          "http"
								containerPort: 80
								protocol:      "TCP"
							}, // endif
						]
						if _config.livenessProbe != _|_ {
							livenessProbe: _config.livenessProbe
						}
						if _config.readinessProbe != _|_ {
							readinessProbe: _config.readinessProbe
						}
						if _config.volumeMounts != _|_ {
							volumeMounts: _config.volumeMounts
						}
						if _config.resources != _|_ {
							resources: _config.resources
						}
						if _config.securityContext != _|_ {
							securityContext: _config.securityContext
						}
					},
					if _config.sidecarContainers != _|_ {
						for container in _config.sidecarContainers {
							container
						}
					},
				]
				if _config.volumes != _|_ {
					volumes: _config.Volumes
				}
				if _config.podSecurityContext != _|_ {
					securityContext: _config.podSecurityContext
				}
				if _config.topologySpreadConstraints != _|_ {
					topologySpreadConstraints: _config.topologySpreadConstraints
				}
				if _config.affinity != _|_ {
					affinity: _config.affinity
				}
				if _config.tolerations != _|_ {
					tolerations: _config.tolerations
				}
				if _config.imagePullSecrets != _|_ {
					imagePullSecrets: _config.imagePullSecrets
				}
			}
		}
	}
}
