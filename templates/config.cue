package templates

import (
	corev1 "k8s.io/api/core/v1"
	timoniv1 "timoni.sh/core/v1alpha1"
)

// Config defines the schema and defaults for the Instance values.
#Config: {
	// Runtime version info
	moduleVersion!: string
	kubeVersion!:   string

	// Metadata (common to all resources)
	metadata: timoniv1.#Metadata
	metadata: version: moduleVersion

	// Deployment

	replicas: *1 | int & >0

	// Pod
	podAnnotations?: {[ string]: string}
	podSecurityContext?: corev1.#PodSecurityContext
	imagePullSecrets?: [...corev1.LocalObjectReference]
	tolerations?: [ ...corev1.#Toleration]
	affinity?: corev1.#Affinity
	topologySpreadConstraints?: [...corev1.#TopologySpreadConstraint]
	volumes?: [...corev1.#Volumes]

	// Containers
	// main
	image:           timoniv1.#Image
	imagePullPolicy: *"IfNotPresent" | string
	livenessProbe?:  corev1.#Probe
	readinessProbe?: corev1.#Probe
	volumeMounts?: [...corev1.#VolumeMount]
	ports?: [...corev1.#ContainerPort]
	resources?:       corev1.#ResourceRequirements
	securityContext?: corev1.#SecurityContext

	// additional
	sidecarContainers?: [...corev1.#Container]

	// Service
	service: {
		port:     *80 | int & >0 & <=65535
		protocol: *"TCP" | string
	}

	ingress: {
		create: *false | bool
		host:   *"" | string
		http: [{
			path: *"/" | string
			port: *80 | int & >0 & <=65535
		}]
	}

	configMap: {
		create:    *false | bool
		immutable: *true | bool
		// data: *{} 
	}
}

// Instance takes the config values and outputs the Kubernetes objects.
#Instance: {
	config: #Config

	objects: {
		sa:  #ServiceAccount & {_config: config}
		svc: #Service & {_config:        config}

		if config.ingress.create {
			ing: #Ingress & {_config: config}
		}

		if config.configMap.create {
			cm: #ConfigMap & {_config: config}
		}
		deploy: #Deployment & {
			_config: config
		}
	}
}
