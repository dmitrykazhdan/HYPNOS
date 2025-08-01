#!/usr/bin/env python3
"""
Data Enricher for SleepQA Dataset
Takes brief answers and enriches them into full sentences using GPT
"""
import json
import os
import argparse
from dotenv import load_dotenv
from sleepqa_enricher import SleepQADataEnricher

load_dotenv()

def parse_command_line_arguments():
    """Parse command line arguments"""
    parser = argparse.ArgumentParser(
        description='Enrich SleepQA dataset with detailed answers using GPT',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
            Examples:
            python main.py --csv sleep-data.csv
            python main.py --csv sleep-data.csv --batch-size 5 --max-items 100
            python main.py --csv sleep-data.csv --max-items 50
                    """
    )
    
    parser.add_argument(
        '--csv', 
        type=str, 
        help='Path to the CSV file containing sleep Q&A data (default: sleep-test.csv)'
    )
    
    parser.add_argument(
        '--batch-size', 
        type=int, 
        default=10,
        help='Number of items to process in each batch (default: 10)'
    )
    
    parser.add_argument(
        '--max-items', 
        type=int, 
        help='Maximum number of items to process (default: process all items)'
    )
    
    return parser.parse_args()

def main():
    openai_api_key = os.getenv('OPENAI_API_KEY')

    if not openai_api_key:
        print("❌ No OpenAI API key found. Please set OPENAI_API_KEY in your .env file")
        return

    args = parse_command_line_arguments()
    
    csv_path = args.csv
    batch_size = args.batch_size
    max_items = args.max_items
    
    enricher = SleepQADataEnricher(openai_api_key=openai_api_key)
    
    if os.path.exists(csv_path):
        print(f"🚀 Starting dataset enrichment...")
        print(f"   CSV file: {csv_path}")
        print(f"   Batch size: {batch_size}")
        print(f"   Max items: {max_items if max_items else 'All items'}")
        
        output_path = enricher.enrich_dataset(
            csv_path=csv_path,
            max_items=max_items,
            batch_size=batch_size
        )
        
        if output_path and os.path.exists(output_path):
            with open(output_path, 'r', encoding='utf-8') as f:
                enriched_data = json.load(f)
            
            print(f"\n📊 Enrichment Summary:")
            print(f"   Total items processed: {len(enriched_data)}")
            print(f"   Output file: {output_path}")
            
    else:
        print(f"❌ CSV file not found: {csv_path}")
        print("💡 Make sure the CSV file exists in the specified path")

if __name__ == "__main__":
    main()
