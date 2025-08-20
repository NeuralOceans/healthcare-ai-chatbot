# Trend Micro Artifact Scanner (TMAS) Integration Guide

## Overview

This guide explains how to integrate Trend Micro Artifact Scanner (TMAS) into your healthcare AI chatbot's CI/CD pipeline for comprehensive security scanning.

## What is TMAS?

Trend Micro Artifact Scanner (TMAS) is a pre-runtime security scanning tool that performs:
- **Vulnerability scanning**: Open source vulnerability detection using up-to-date threat feeds
- **Malware detection**: Detection of trojans, ransomware, spyware, and polymorphic variants
- **Secret scanning**: Hard-coded passwords, API keys, tokens, and sensitive data detection
- **SBOM generation**: Software Bill of Materials for compliance and tracking

## Healthcare-Specific Security Benefits

For healthcare applications handling PHI (Protected Health Information), TMAS provides:
- HIPAA compliance validation
- Patient data exposure risk assessment
- Medical terminology false-positive filtering
- Healthcare-specific threat detection patterns

## Prerequisites

### 1. TMAS API Key
Get your API key from either:
- **Trend Cloud One**: Container Security → Scanners → Create API Key
- **Trend Vision One**: Code Security → Generate API Key

### 2. Required Environment Variables
```bash
TMAS_API_KEY=your_api_key_here
TMAS_REGION=us-1  # or your preferred region
```

### 3. Healthcare Override Configuration
The project includes `tmas_healthcare_overrides.yml` with:
- Medical terminology whitelisting
- Healthcare-specific compliance checks
- HIPAA-related security patterns
- False positive filtering for legitimate medical terms

## CI/CD Integration

### GitHub Actions
The project includes `.github/workflows/ci-cd-with-tmas.yml` with:
- Automated TMAS scanning on every build
- Healthcare-specific security validation
- SARIF output for GitHub Security tab integration
- Deployment gates based on scan results

### Azure DevOps
Use `azure-pipelines.yml` for Azure DevOps integration:
- Multi-stage pipeline with security scanning
- TMAS result analysis and reporting
- Conditional deployment based on security findings

### GitLab CI
Use `gitlab-ci.yml` for GitLab integration:
- Docker-based TMAS scanning
- Artifact storage for scan results
- Environment-specific deployment controls

### Jenkins
Use `jenkins/Jenkinsfile` for Jenkins integration:
- Pipeline-as-code with TMAS integration
- Manual approval gates for production
- Email notifications with scan results

## Usage Examples

### Basic Container Scan
```bash
# Scan built container image
tmas scan registry:your-registry/healthcare-ai-chatbot:latest -VMS

# With healthcare overrides
tmas scan registry:your-registry/healthcare-ai-chatbot:latest -VMS \
  --override tmas_healthcare_overrides.yml
```

### Local Development Scan
```bash
# Scan current directory
npm run security:tmas

# Or directly
tmas scan . -VMS --override tmas_healthcare_overrides.yml
```

### CI/CD Pipeline Scan
```bash
# Full scan with SBOM generation
tmas scan registry:$IMAGE_TAG -VMS \
  --output-format json \
  --output-file tmas-scan-results.json \
  --save-sbom \
  --override tmas_healthcare_overrides.yml
```

## Healthcare Override Configuration

### Key Features in `tmas_healthcare_overrides.yml`:

#### Vulnerability Overrides
```yaml
vulnerabilities:
  - id: "CVE-2023-44270"
    reason: "PostCSS vulnerability - build-time only, doesn't affect runtime healthcare data"
```

#### Secret Pattern Exclusions
```yaml
secrets:
  - pattern: "mock_ssn_*"
    reason: "Mock SSN patterns for form testing, not real patient data"
```

#### Healthcare Compliance Checks
```yaml
compliance:
  hipaa:
    encryption_at_rest: required
    encryption_in_transit: required
    audit_logging: required
    access_controls: required
```

#### Custom Security Patterns
```yaml
healthcare_patterns:
  - pattern: "patient.*data.*log"
    severity: "high"
    reason: "Potential PHI logging - review for HIPAA compliance"
```

## Security Scan Results

### Critical Issues (Build Fails)
- Critical vulnerabilities
- Malware detection
- PHI exposure risks
- Authentication bypass vulnerabilities

### Warning Issues (Build Continues)
- High vulnerabilities (> 5)
- Secrets detected
- Outdated dependencies (> 10)

### Result Formats
- **JSON**: Detailed programmatic analysis
- **SARIF**: GitHub Security integration
- **SBOM**: Software Bill of Materials

## Deployment Gates

### Staging Environment
- Deploy on `develop` branch
- Warning on high-risk issues
- Continue deployment with notifications

### Production Environment
- Deploy on `main` branch only
- Fail on any critical issues
- Manual approval required
- Final security validation before deployment

## Monitoring and Compliance

### Dashboard Integration
TMAS results are automatically sent to:
- Trend Cloud One Container Security dashboard
- Trend Vision One Code Security dashboard
- GitHub Security tab (via SARIF upload)

### Compliance Reporting
- 30-day scan validity for admission control
- Healthcare-specific compliance metrics
- HIPAA assessment reports
- PHI risk analysis

## Best Practices

### 1. Regular Scanning
- Scan on every build
- Re-scan images every 30 days
- Update override configurations quarterly

### 2. Security Hygiene
- Review high and medium vulnerabilities weekly
- Update base images regularly
- Monitor for new healthcare threat patterns

### 3. Incident Response
- Immediate response for critical findings
- Document all override decisions
- Regular security review meetings

### 4. Compliance Maintenance
- Regular HIPAA compliance audits
- Update healthcare patterns based on new threats
- Maintain audit trails for all security decisions

## Troubleshooting

### Common Issues

#### Authentication Failures
```bash
# Verify API key and region
tmas configure --api-key $TMAS_API_KEY --region $TMAS_REGION
tmas version
```

#### Memory Issues with Large Images
```bash
# Increase available memory or use multi-stage builds
docker build --memory=4g -t healthcare-ai-chatbot .
```

#### Network Connectivity
```bash
# Test connectivity to Trend Micro cloud services
curl -I https://cloudone.trendmicro.com
```

### Debug Commands
```bash
# Verify TMAS configuration
tmas version

# Test API connectivity
tmas scan --dry-run registry:alpine:latest

# Validate override file
tmas scan . --override tmas_healthcare_overrides.yml --dry-run
```

## Support and Resources

### Documentation
- [Official TMAS Documentation](https://docs.trendmicro.com/en-us/documentation/article/trend-vision-one-artifact-scanner-tmas)
- [Container Security Guide](https://cloudone.trendmicro.com/docs/container-security/)

### Healthcare Security Resources
- HIPAA Security Rule compliance guides
- Healthcare cybersecurity frameworks
- Medical device security standards

### Getting Help
- Trend Micro Support Portal
- Container Security community forums
- Healthcare cybersecurity working groups

## Conclusion

TMAS integration provides comprehensive security scanning specifically tailored for healthcare applications. The combination of vulnerability detection, malware scanning, and secret detection ensures that your healthcare AI chatbot meets security and compliance requirements before deployment.

Regular scanning and proper configuration of healthcare-specific overrides help maintain security posture while reducing false positives common in medical applications.