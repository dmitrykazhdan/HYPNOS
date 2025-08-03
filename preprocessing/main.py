#!/usr/bin/env python3
"""
Data Enricher for SleepQA Dataset
Takes brief answers and enriches them into full sentences using GPT
Supports both SFT and DPO data generation
"""
import json
import os
import argparse
from dotenv import load_dotenv
from sleepqa_enricher import SleepQADataEnricher
from sleepqa_enricher_dpo import SleepQADataEnricherDPO

load_dotenv()

def parse_command_line_arguments():
    """Parse command line arguments"""
    parser = argparse.ArgumentParser(
        description='Enrich SleepQA dataset with detailed answers using GPT (SFT) or generate DPO training data',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
            Examples:
            # SFT mode (enrich CSV data)
            python main.py --sft --csv sleep-data.csv
            python main.py --sft --csv sleep-data.csv --batch-size 5 --max-items 100
            
            # DPO mode (generate chosen/rejected pairs from JSON)
            python main.py --dpo --json enriched-sleep-data.json
            python main.py --dpo --json enriched-sleep-data.json --max-items 50
                    """
    )
    # python main.py --dpo --json /Users/AdminDK/HYPNOS/data/sleep-train-enriched.json --max-items 5

    
    # Mode selection
    mode_group = parser.add_mutually_exclusive_group(required=True)
    mode_group.add_argument(
        '--sft', 
        action='store_true',
        help='SFT mode: enrich CSV data with detailed answers'
    )
    mode_group.add_argument(
        '--dpo', 
        action='store_true',
        help='DPO mode: generate chosen/rejected response pairs from JSON data'
    )
    
    # Input file arguments
    parser.add_argument(
        '--csv', 
        type=str, 
        help='Path to the CSV file containing sleep Q&A data (required for SFT mode)'
    )
    
    parser.add_argument(
        '--json', 
        type=str, 
        help='Path to the JSON file containing enriched sleep Q&A data (required for DPO mode)'
    )
    
    # Processing arguments
    parser.add_argument(
        '--batch-size', 
        type=int, 
        default=10,
        help='Number of items to process in each batch (SFT mode only, default: 10)'
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
    
    if args.sft:
        # SFT mode: enrich CSV data
        if not args.csv:
            print("❌ CSV file path required for SFT mode. Use --csv <path>")
            return
    
    csv_path = args.csv
    batch_size = args.batch_size
    max_items = args.max_items
    
        if not os.path.exists(csv_path):
            print(f"❌ CSV file not found: {csv_path}")
            print("💡 Make sure the CSV file exists in the specified path")
            return
    
        print(f"🚀 Starting SFT dataset enrichment...")
        print(f"   CSV file: {csv_path}")
        print(f"   Batch size: {batch_size}")
        print(f"   Max items: {max_items if max_items else 'All items'}")
        
        enricher = SleepQADataEnricher(openai_api_key=openai_api_key)
        output_path = enricher.enrich_dataset(
            csv_path=csv_path,
            max_items=max_items,
            batch_size=batch_size
        )
        
        if output_path and os.path.exists(output_path):
            with open(output_path, 'r', encoding='utf-8') as f:
                enriched_data = json.load(f)
            
            print(f"\n📊 SFT Enrichment Summary:")
            print(f"   Total items processed: {len(enriched_data)}")
            print(f"   Output file: {output_path}")
            
    elif args.dpo:
        # DPO mode: generate chosen/rejected pairs from JSON
        if not args.json:
            print("❌ JSON file path required for DPO mode. Use --json <path>")
            return
            
        json_path = args.json
        max_items = args.max_items
        
        if not os.path.exists(json_path):
            print(f"❌ JSON file not found: {json_path}")
            print("💡 Make sure the JSON file exists in the specified path")
            return
        
        print(f"🚀 Starting DPO dataset generation...")
        print(f"   JSON file: {json_path}")
        print(f"   Max items: {max_items if max_items else 'All items'}")
        
        dpo_enricher = SleepQADataEnricherDPO(openai_api_key=openai_api_key)
        output_path = dpo_enricher.enrich_dataset_dpo(
            json_path=json_path,
            max_items=max_items,
            batch_size=args.batch_size
        )
        
        if output_path and os.path.exists(output_path):
            with open(output_path, 'r', encoding='utf-8') as f:
                dpo_data = json.load(f)
            
            print(f"\n📊 DPO Generation Summary:")
            print(f"   Total items processed: {len(dpo_data)}")
            print(f"   Output file: {output_path}")
            print(f"   Format: question, chosen, rejected, original_answer")

if __name__ == "__main__":
    main()
