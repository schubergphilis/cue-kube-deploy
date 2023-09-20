package templates

import (
	"encoding/yaml"
	"strings"
	"uuid"

	corev1 "k8s.io/api/core/v1"
)

#ConfigMap: corev1.#ConfigMap & {
	_config:    #Config
	apiVersion: "v1"
	kind:       "ConfigMap"
	metadata: {
		name:      "\(_config.metadata.name)-\(_checksum)"
		namespace: _config.metadata.namespace
		labels:    _config.metadata.labels
		if _config.metadata.annotations != _|_ {
			annotations: _config.metadata.annotations
		}
	}
	immutable: true
	let _checksum = strings.Split(uuid.SHA1(uuid.ns.DNS, yaml.Marshal(data)), "-")[0]
	data: {}
}
