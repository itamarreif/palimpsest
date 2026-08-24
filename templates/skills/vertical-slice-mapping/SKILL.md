---
name: vertical-slice-mapping
description: Use before implementing or refactoring a flow that crosses handlers, services, persistence, events, jobs, or external systems.
user-invocable: true
persona: collaborator
created: TODO
---

# Vertical Slice Mapping

Draw before and after call graphs for the affected flow. Mark reads, writes, external calls, and durable side effects. Name the true entrypoint and test seam before adding tests or moving logic.
