# CKS study guide

1. [CIS Kubernetes Benchmark](https://www.cisecurity.org/benchmark/kubernetes/)

    1.1. [Kube-bench](https://github.com/aquasecurity/kube-bench) [(running inside a container)](https://www.cisecurity.org/benchmark/kubernetes/)

2. Ingress (TLS)

3. Network Policy

    3.1. Node metadata

    ```yaml
    apiVersion: networking.k8s.io/v1
    kind: NetworkPolicy
    metadata:
      name: block-metadata
    spec:
      podSelector: {}
      policyTypes:
        - Egress
      egress:
        - to:
          - ipBlock:
              cidr: 0.0.0.0/0
              except: 169.254.169.254/32
    ```

4. ServiceAccount (SA)

    - Disable SA mount in pod

    ```yaml
    # Inside SA object
    # OR
    # Inside spec.containers[]
    automountServiceAccountToken: false
    ```

5. RBAC

    - Roles (namespace)
    - ClusterRoles (global)

6. PSP (Deprecated)

7. SecurityContext
