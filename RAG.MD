# RAG - Reference & Lookup Library

## Purpose

This RAG (Retrieval-Augmented Generation) document serves as a reference and lookup library for the AxiumGST project. Its primary purpose is to optimize LLM efficiency by maintaining a searchable index of previously conducted research and lookups.

## How It Works

When a search or lookup is performed (either in local `/docs` directory or on the internet), the following information is recorded in this RAG:

1. **Search Query/Text**: The actual search terms or questions used
2. **Reference/Link**: Direct links to sources or file references
3. **Key Findings**: Brief summary of relevant information found
4. **Date**: When the lookup was performed

## Benefits

- **Avoid Redundant Searches**: Prevents the LLM from repeating searches in areas already covered
- **Quick Reference**: Enables fast retrieval of previously found information
- **Knowledge Accumulation**: Builds a growing knowledge base specific to the project
- **Cost Optimization**: Reduces API calls and processing time by reusing existing research

## Usage Guidelines

### Adding Entries

When documenting a new lookup, use the following format:

```markdown
### [Topic/Area]
**Date**: YYYY-MM-DD
**Query**: [Search text or question]
**Source**: [Link or file path]
**Summary**: [Brief description of findings]
```

### Categories

Entries should be organized under relevant categories:
- Local Documentation Searches
- Internet/Web Research
- API Documentation Lookups
- Technical Specifications
- Code Examples & Patterns

---

## Research Entries

<!-- New entries are added below this line -->
