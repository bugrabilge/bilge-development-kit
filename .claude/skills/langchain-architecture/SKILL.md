---
user-invocable: false
name: langchain-architecture
description: "Design LLM applications using LangChain and LangGraph frameworks with agents, memory, tool integration, state management, and production deployment patterns. Covers LangChain 0.1+ and LangGraph APIs."
risk: unknown
source: community
---

# LangChain Architecture

Master the LangChain framework for building sophisticated LLM applications with agents, chains, memory, and tool integration.

## Do not use this skill when

- The task is unrelated to langchain architecture
- You need a different domain or tool outside this scope

## Instructions

- Clarify goals, constraints, and required inputs.
- Apply relevant best practices and validate outcomes.
- Provide actionable steps and verification.
- If detailed examples are required, open `resources/implementation-playbook.md`.

## Use this skill when

- Building autonomous AI agents with tool access
- Implementing complex multi-step LLM workflows
- Managing conversation memory and state
- Integrating LLMs with external data sources and APIs
- Creating modular, reusable LLM application components
- Implementing document processing pipelines
- Building production-grade LLM applications

## Core Concepts

### 1. Agents
Autonomous systems that use LLMs to decide which actions to take.

**Agent Types:**
- **ReAct**: Reasoning + Acting in interleaved manner
- **OpenAI Functions**: Leverages function calling API
- **Structured Chat**: Handles multi-input tools
- **Conversational**: Optimized for chat interfaces
- **Self-Ask with Search**: Decomposes complex queries

### 2. Chains
Sequences of calls to LLMs or other utilities.

**Chain Types:**
- **LLMChain**: Basic prompt + LLM combination
- **SequentialChain**: Multiple chains in sequence
- **RouterChain**: Routes inputs to specialized chains
- **TransformChain**: Data transformations between steps
- **MapReduceChain**: Parallel processing with aggregation

### 3. Memory
Systems for maintaining context across interactions.

**Memory Types:**
- **ConversationBufferMemory**: Stores all messages
- **ConversationSummaryMemory**: Summarizes older messages
- **ConversationBufferWindowMemory**: Keeps last N messages
- **EntityMemory**: Tracks information about entities
- **VectorStoreMemory**: Semantic similarity retrieval

### 4. Document Processing
Loading, transforming, and storing documents for retrieval.

**Components:**
- **Document Loaders**: Load from various sources
- **Text Splitters**: Chunk documents intelligently
- **Vector Stores**: Store and retrieve embeddings
- **Retrievers**: Fetch relevant documents
- **Indexes**: Organize documents for efficient access

### 5. Callbacks
Hooks for logging, monitoring, and debugging.

**Use Cases:**
- Request/response logging
- Token usage tracking
- Latency monitoring
- Error handling
- Custom metrics collection

## Quick Start

```python
from langchain.agents import AgentType, initialize_agent, load_tools
from langchain.llms import OpenAI
from langchain.memory import ConversationBufferMemory

# Initialize LLM
llm = OpenAI(temperature=0)

# Load tools
tools = load_tools(["serpapi", "llm-math"], llm=llm)

# Add memory
memory = ConversationBufferMemory(memory_key="chat_history")

# Create agent
agent = initialize_agent(
    tools,
    llm,
    agent=AgentType.CONVERSATIONAL_REACT_DESCRIPTION,
    memory=memory,
    verbose=True
)

# Run agent
result = agent.run("What's the weather in SF? Then calculate 25 * 4")
```

## Architecture Patterns

### Pattern 1: RAG with LangChain
```python
from langchain.chains import RetrievalQA
from langchain.document_loaders import TextLoader
from langchain.text_splitter import CharacterTextSplitter
from langchain.vectorstores import Chroma
from langchain.embeddings import OpenAIEmbeddings

# Load and process documents
loader = TextLoader('documents.txt')
documents = loader.load()

text_splitter = CharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
texts = text_splitter.split_documents(documents)

# Create vector store
embeddings = OpenAIEmbeddings()
vectorstore = Chroma.from_documents(texts, embeddings)

# Create retrieval chain
qa_chain = RetrievalQA.from_chain_type(
    llm=llm,
    chain_type="stuff",
    retriever=vectorstore.as_retriever(),
    return_source_documents=True
)

# Query
result = qa_chain({"query": "What is the main topic?"})
```

### Pattern 2: Custom Agent with Tools
```python
from langchain.agents import Tool, AgentExecutor
from langchain.agents.react.base import ReActDocstoreAgent
from langchain.tools import tool

@tool
def search_database(query: str) -> str:
    """Search internal database for information."""
    # Your database search logic
    return f"Results for: {query}"

@tool
def send_email(recipient: str, content: str) -> str:
    """Send an email to specified recipient."""
    # Email sending logic
    return f"Email sent to {recipient}"

tools = [search_database, send_email]

agent = initialize_agent(
    tools,
    llm,
    agent=AgentType.ZERO_SHOT_REACT_DESCRIPTION,
    verbose=True
)
```

### Pattern 3: Multi-Step Chain
```python
from langchain.chains import LLMChain, SequentialChain
from langchain.prompts import PromptTemplate

# Step 1: Extract key information
extract_prompt = PromptTemplate(
    input_variables=["text"],
    template="Extract key entities from: {text}\n\nEntities:"
)
extract_chain = LLMChain(llm=llm, prompt=extract_prompt, output_key="entities")

# Step 2: Analyze entities
analyze_prompt = PromptTemplate(
    input_variables=["entities"],
    template="Analyze these entities: {entities}\n\nAnalysis:"
)
analyze_chain = LLMChain(llm=llm, prompt=analyze_prompt, output_key="analysis")

# Step 3: Generate summary
summary_prompt = PromptTemplate(
    input_variables=["entities", "analysis"],
    template="Summarize:\nEntities: {entities}\nAnalysis: {analysis}\n\nSummary:"
)
summary_chain = LLMChain(llm=llm, prompt=summary_prompt, output_key="summary")

# Combine into sequential chain
overall_chain = SequentialChain(
    chains=[extract_chain, analyze_chain, summary_chain],
    input_variables=["text"],
    output_variables=["entities", "analysis", "summary"],
    verbose=True
)
```

## Memory Management Best Practices

### Choosing the Right Memory Type
```python
# For short conversations (< 10 messages)
from langchain.memory import ConversationBufferMemory
memory = ConversationBufferMemory()

# For long conversations (summarize old messages)
from langchain.memory import ConversationSummaryMemory
memory = ConversationSummaryMemory(llm=llm)

# For sliding window (last N messages)
from langchain.memory import ConversationBufferWindowMemory
memory = ConversationBufferWindowMemory(k=5)

# For entity tracking
from langchain.memory import ConversationEntityMemory
memory = ConversationEntityMemory(llm=llm)

# For semantic retrieval of relevant history
from langchain.memory import VectorStoreRetrieverMemory
memory = VectorStoreRetrieverMemory(retriever=retriever)
```

## Callback System

### Custom Callback Handler
```python
from langchain.callbacks.base import BaseCallbackHandler

class CustomCallbackHandler(BaseCallbackHandler):
    def on_llm_start(self, serialized, prompts, **kwargs):
        print(f"LLM started with prompts: {prompts}")

    def on_llm_end(self, response, **kwargs):
        print(f"LLM ended with response: {response}")

    def on_llm_error(self, error, **kwargs):
        print(f"LLM error: {error}")

    def on_chain_start(self, serialized, inputs, **kwargs):
        print(f"Chain started with inputs: {inputs}")

    def on_agent_action(self, action, **kwargs):
        print(f"Agent taking action: {action}")

# Use callback
agent.run("query", callbacks=[CustomCallbackHandler()])
```

## Testing Strategies

```python
import pytest
from unittest.mock import Mock

def test_agent_tool_selection():
    # Mock LLM to return specific tool selection
    mock_llm = Mock()
    mock_llm.predict.return_value = "Action: search_database\nAction Input: test query"

    agent = initialize_agent(tools, mock_llm, agent=AgentType.ZERO_SHOT_REACT_DESCRIPTION)

    result = agent.run("test query")

    # Verify correct tool was selected
    assert "search_database" in str(mock_llm.predict.call_args)

def test_memory_persistence():
    memory = ConversationBufferMemory()

    memory.save_context({"input": "Hi"}, {"output": "Hello!"})

    assert "Hi" in memory.load_memory_variables({})['history']
    assert "Hello!" in memory.load_memory_variables({})['history']
```

## Performance Optimization

### 1. Caching
```python
from langchain.cache import InMemoryCache
import langchain

langchain.llm_cache = InMemoryCache()
```

### 2. Batch Processing
```python
# Process multiple documents in parallel
from langchain.document_loaders import DirectoryLoader
from concurrent.futures import ThreadPoolExecutor

loader = DirectoryLoader('./docs')
docs = loader.load()

def process_doc(doc):
    return text_splitter.split_documents([doc])

with ThreadPoolExecutor(max_workers=4) as executor:
    split_docs = list(executor.map(process_doc, docs))
```

### 3. Streaming Responses
```python
from langchain.callbacks.streaming_stdout import StreamingStdOutCallbackHandler

llm = OpenAI(streaming=True, callbacks=[StreamingStdOutCallbackHandler()])
```

## Resources

- **references/agents.md**: Deep dive on agent architectures
- **references/memory.md**: Memory system patterns
- **references/chains.md**: Chain composition strategies
- **references/document-processing.md**: Document loading and indexing
- **references/callbacks.md**: Monitoring and observability
- **assets/agent-template.py**: Production-ready agent template
- **assets/memory-config.yaml**: Memory configuration examples
- **assets/chain-example.py**: Complex chain examples

## Common Pitfalls

1. **Memory Overflow**: Not managing conversation history length
2. **Tool Selection Errors**: Poor tool descriptions confuse agents
3. **Context Window Exceeded**: Exceeding LLM token limits
4. **No Error Handling**: Not catching and handling agent failures
5. **Inefficient Retrieval**: Not optimizing vector store queries

## Production Checklist

- [ ] Implement proper error handling
- [ ] Add request/response logging
- [ ] Monitor token usage and costs
- [ ] Set timeout limits for agent execution
- [ ] Implement rate limiting
- [ ] Add input validation
- [ ] Test with edge cases
- [ ] Set up observability (callbacks)
- [ ] Implement fallback strategies
- [ ] Version control prompts and configurations

---

## LangGraph State Management

### State Graph Pattern

```python
from langgraph.graph import StateGraph, MessagesState, START, END
from langgraph.prebuilt import create_react_agent
from langchain_anthropic import ChatAnthropic

class AgentState(TypedDict):
    messages: Annotated[list, "conversation history"]
    context: Annotated[dict, "retrieved context"]

builder = StateGraph(MessagesState)
builder.add_node("node1", node1_func)
builder.add_node("node2", node2_func)
builder.add_edge(START, "node1")
builder.add_conditional_edges("node1", router, {"a": "node2", "b": END})
builder.add_edge("node2", END)
agent = builder.compile(checkpointer=checkpointer)
```

### Multi-Agent Orchestration with LangGraph

- Use `Command[Literal["agent1", "agent2", END]]` for routing between agents
- Supervisor agent decides next agent based on context and task requirements
- Track progress through shared state across agent nodes

## Recommended Model & Embeddings

| Purpose | Model | Notes |
|---------|-------|-------|
| **Primary LLM** | Claude Sonnet 4.5 | Best balance of quality and speed |
| **Embeddings** | Voyage AI `voyage-3-large` | Officially recommended for Claude |
| **Code embeddings** | `voyage-code-3` | Optimized for code search |
| **Domain-specific** | `voyage-finance-2`, `voyage-law-2` | Specialized domains |

## Advanced RAG with LangChain

### HyDE (Hypothetical Document Embeddings)

Generate a hypothetical answer to the query, embed that, and use it for retrieval. Improves recall for abstract queries.

### RAG Fusion

Generate multiple query perspectives, retrieve for each, then merge results using Reciprocal Rank Fusion.

### Reranking Pipeline

```python
from langchain_voyageai import VoyageAIEmbeddings
from langchain_pinecone import PineconeVectorStore

embeddings = VoyageAIEmbeddings(model="voyage-3-large")
vectorstore = PineconeVectorStore(index=index, embedding=embeddings)

# Retrieve with hybrid search, then rerank
base_retriever = vectorstore.as_retriever(
    search_type="hybrid",
    search_kwargs={"k": 20, "alpha": 0.5}
)
```

## Production Deployment with FastAPI

```python
from fastapi import FastAPI
from fastapi.responses import StreamingResponse

@app.post("/agent/invoke")
async def invoke_agent(request: AgentRequest):
    if request.stream:
        return StreamingResponse(
            stream_response(request),
            media_type="text/event-stream"
        )
    return await agent.ainvoke({"messages": [...]})
```

## Async Patterns

Always use async methods in production for better concurrency:

```python
async def process_request(message: str, session_id: str):
    result = await agent.ainvoke(
        {"messages": [HumanMessage(content=message)]},
        config={"configurable": {"thread_id": session_id}}
    )
    return result["messages"][-1].content
```

## Monitoring & Observability

| Tool | Purpose |
|------|---------|
| **LangSmith** | Trace all agent executions, debug chains |
| **Prometheus** | Track requests, latency, error rates |
| **Structured logging** | Use `structlog` for consistent logs |
| **Health checks** | Validate LLM, tools, memory, and external services |

## LangGraph Best Practices

1. **Always use async**: `ainvoke`, `astream`, `aget_relevant_documents`
2. **Handle errors gracefully**: Try/except with fallbacks and retries
3. **Monitor everything**: Trace, log, and collect metrics on all operations
4. **Optimize costs**: Cache responses, set token limits, compress memory
5. **Secure secrets**: Environment variables, never hardcode API keys
6. **Version control state**: Use checkpointers for reproducibility
7. **Test with evaluation suites**: Use LangSmith evaluation framework
