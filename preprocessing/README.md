# 🔄 HYPNOS Data Preprocessing

Tools for preparing and enriching training data for the HYPNOS AI model.

## ✨ Features

- 📊 **Data Enrichment** - Enhance SleepQA dataset with GPT
- 🎯 **DPO Training** - Generate chosen/rejected pairs
- 🔧 **SFT Mode** - Supervised Fine-Tuning data preparation
- 📈 **Batch Processing** - Handle large datasets efficiently
- 🔑 **OpenAI Integration** - Uses GPT for data enhancement

## 🚀 Quick Start

```bash
# Install dependencies
pip install -r requirements.txt

# SFT mode - enrich CSV data
python main.py --sft --csv sleep-data.csv

# DPO mode - generate training pairs
python main.py --dpo --json enriched-data.json
```

## 📁 Files

- `main.py` - Main preprocessing pipeline
- `sleepqa_enricher.py` - SFT data enrichment
- `sleepqa_enricher_dpo.py` - DPO pair generation
- `requirements.txt` - Python dependencies

## 🔧 Configuration

- **OpenAI API Key**: Set in `.env` file
- **Input Formats**: CSV (SFT) or JSON (DPO)
- **Batch Size**: Configurable processing batches
- **Max Items**: Limit processing amount

## 🏗️ Architecture

- **Pandas** - Data manipulation
- **OpenAI API** - GPT integration
- **Argparse** - Command line interface
- **JSON** - Data serialization

## 📦 Dependencies

- `pandas` - Data processing
- `openai` - GPT API integration
- `python-dotenv` - Environment variables 