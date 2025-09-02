#!/usr/bin/env python3
"""
Harness Terraform Module Documentation Generator
Generates README.md from README.yaml for consistent team documentation
"""

import yaml
import sys
import os
from pathlib import Path

def load_readme_config(yaml_path):
    """Load and parse README.yaml configuration"""
    try:
        with open(yaml_path, 'r') as f:
            return yaml.safe_load(f)
    except FileNotFoundError:
        print(f"Error: {yaml_path} not found")
        sys.exit(1)
    except yaml.YAMLError as e:
        print(f"Error parsing YAML: {e}")
        sys.exit(1)

def generate_terraform_docs_table():
    """Generate terraform-docs table if available, otherwise return placeholder"""
    try:
        # Check if terraform-docs is available
        import subprocess
        result = subprocess.run(['terraform-docs', 'markdown', 'table', '.'], 
                              capture_output=True, text=True, check=True)
        return result.stdout.strip()
    except (subprocess.CalledProcessError, FileNotFoundError):
        return """<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->"""

def format_usage_examples(usage_examples):
    """Format usage examples section"""
    if not usage_examples:
        return ""
    
    content = "## Usage\n\n"
    
    for example in usage_examples:
        if 'name' in example:
            content += f"### {example['name']}\n\n"
        
        if 'description' in example:
            content += f"{example['description']}\n\n"
        
        if 'code' in example:
            content += f"```hcl\n{example['code']}\n```\n\n"
    
    return content

def format_examples_section(examples):
    """Format examples section"""
    if not examples:
        return ""
    
    content = "## Examples\n\n"
    
    for example in examples:
        content += f"- **{example['name']}**: {example['description']}\n"
        if 'url' in example:
            content += f"  - [View Example]({example['url']})\n"
    
    content += "\n"
    return content

def format_related_projects(related):
    """Format related projects section"""
    if not related:
        return ""
    
    content = "## Related Projects\n\n"
    
    for project in related:
        content += f"- [{project['name']}]({project['url']}) - {project['description']}\n"
    
    content += "\n"
    return content

def format_contributors(contributors):
    """Format contributors section"""
    if not contributors:
        return ""
    
    content = "## Contributors\n\n"
    content += "| Avatar | Name | Email |\n"
    content += "|--------|------|-------|\n"
    
    for contributor in contributors:
        avatar = contributor.get('avatar', '')
        name = contributor.get('name', '')
        email = contributor.get('email', '')
        github = contributor.get('github', '')
        
        if github:
            name_link = f"[{name}](https://github.com/{github})"
        else:
            name_link = name
            
        if avatar:
            avatar_img = f'<img src="{avatar}" width="32" height="32" alt="{name}">'
        else:
            avatar_img = ""
            
        content += f"| {avatar_img} | {name_link} | {email} |\n"
    
    content += "\n"
    return content

def generate_readme(config):
    """Generate complete README.md content"""
    
    # Header section
    readme_content = ""
    
    # Add title and description
    if 'name' in config:
        readme_content += f"# {config['name']}\n\n"
    
    if 'description' in config:
        readme_content += f"{config['description']}\n\n"
    
    # Add badges if present
    if 'badges' in config:
        for badge in config['badges']:
            readme_content += f"[![{badge.get('name', '')}]({badge.get('image', '')})]({badge.get('url', '')})\n"
        readme_content += "\n"
    
    # Add usage examples
    if 'usage' in config:
        readme_content += format_usage_examples(config['usage'])
    
    # Add terraform-docs generated documentation
    readme_content += "## Terraform Documentation\n\n"
    readme_content += generate_terraform_docs_table()
    readme_content += "\n\n"
    
    # Add examples section
    if 'examples' in config:
        readme_content += format_examples_section(config['examples'])
    
    # Add related projects
    if 'related' in config:
        readme_content += format_related_projects(config['related'])
    
    # Add contributors
    if 'contributors' in config:
        readme_content += format_contributors(config['contributors'])
    
    # Add license section
    if 'license' in config:
        readme_content += f"## License\n\n{config['license']}\n\n"
    
    # Add footer
    readme_content += "---\n\n"
    readme_content += "This README was generated from [README.yaml](README.yaml) using the Harness documentation generator.\n"
    
    return readme_content

def main():
    """Main entry point"""
    
    # Get script directory and find README.yaml
    script_dir = Path(__file__).parent
    project_dir = script_dir.parent
    readme_yaml_path = project_dir / 'README.yaml'
    readme_md_path = project_dir / 'README.md'
    
    print(f"Loading configuration from {readme_yaml_path}")
    config = load_readme_config(readme_yaml_path)
    
    print("Generating README.md content...")
    readme_content = generate_readme(config)
    
    print(f"Writing README.md to {readme_md_path}")
    with open(readme_md_path, 'w') as f:
        f.write(readme_content)
    
    print("✓ README.md generated successfully!")

if __name__ == '__main__':
    main()
