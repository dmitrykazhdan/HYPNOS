import pandas as pd
import json
import time
import openai
from typing import List, Dict
import os
from datetime import datetime
import random

class SleepQADataEnricher:
    def __init__(self, openai_api_key: str, model_key: str = "gpt-3.5-turbo"):
        """
        SleeQA Data Enricher using the GPT model
        Current implementation saves to JSON in batches, for reducing the loading/saving from memory
        """
        openai.api_key = openai_api_key
        self.openai_client = openai.OpenAI(api_key=openai_api_key)
        self.model_key = model_key

    def enrich_dataset(self, csv_path: str, output_path: str = None, batch_size: int = 10, max_items: int = None) -> str:
        """Main function to enrich the entire dataset - memory efficient"""
        print("🚀 Starting dataset enrichment...")
        
        data = self._load_sleepqa_csv(csv_path)
        
        if max_items:
            if max_items < len(data):
                data = random.sample(data, max_items)
                print(f"📝 Randomly sampled {max_items} items from {len(data)} total items")
            else:
                print(f"📝 Processing all {len(data)} items (max_items {max_items} >= total items)")
        
        if not data:
            print("❌ No data to process")
            return None
        
        if not output_path:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            output_path = f"enriched_sleepqa_{timestamp}.json"
        
        print(f"📁 Will save to: {output_path}")
        
        n_batches = (len(data) + batch_size - 1) // batch_size
        batch_number = 0

        for i in range(0, len(data), batch_size):
            batch = data[i:i + batch_size]
            batch_number += 1
            print(f"\n📦 Processing batch {batch_number}/{n_batches}")

            enriched_batch = []
            for j, item in enumerate(batch):
                item_index = i + j + 1
                print(f"   Enriching {item_index}/{len(data)}: {item['question'][:50]}...")
                
                enriched_answer = self.enrich_answer_with_gpt(
                    item['question'], 
                    item['answer']
                )
                
                formatted_item = {
                    "question": item['question'],
                    "answer": enriched_answer,
                    "source": "sleepqa_enriched",
                    "original_answer": item['answer']  
                }
                
                enriched_batch.append(formatted_item)
                time.sleep(0.5)  # Rate limiting between API calls
            
            # Save the entire batch at once
            self._append_to_json_file(enriched_batch, output_path)
        
        print(f"\n✅ Enrichment completed!")
        print(f"📁 Saved {len(data)} enriched Q&A pairs to {output_path}")
        print(f"💡 You can now use this file with your dataloader!")
        
        return output_path
 

    def _load_sleepqa_csv(self, csv_path: str) -> List[Dict]:

        print(f"📊 Loading data from {csv_path}...")
        
        try:
            df = pd.read_csv(csv_path, sep='\t', header=None, names=['question', 'answer'])
            print(f"✅ Loaded {len(df)} Q&A pairs")
            
            # Parse the answers (remove quotes and brackets)
            def clean_answer(answer_str):
                """Clean the answer format from SleepQA CSV"""
                if pd.isna(answer_str):
                    return ""
                
                answer = str(answer_str).strip()
                # Remove outer quotes and brackets
                if answer.startswith('"') and answer.endswith('"'):
                    answer = answer[1:-1]
                if answer.startswith('[') and answer.endswith(']'):
                    answer = answer[1:-1]
                # Remove inner quotes
                answer = answer.strip('"').strip("'").strip()
                return answer
            
            df['answer'] = df['answer'].apply(clean_answer)
            
            # Convert to list of dicts
            data = []
            for _, row in df.iterrows():
                if row['question'] and row['answer']:  # Skip empty entries
                    data.append({
                        'question': row['question'].strip(),
                        'answer': row['answer'].strip()
                    })
            
            print(f"✅ Processed {len(data)} valid Q&A pairs")
            return data
            
        except Exception as e:
            print(f"❌ Error loading CSV: {e}")
            return []
    
    def enrich_answer_with_gpt(self, question: str, original_answer: str) -> str:

        prompt = f"""
                You are a sleep expert. Given this question and brief answer, provide a full, detailed sentence that expands on the brief answer while keeping the same meaning and accuracy.

                Question: {question}
                Brief Answer: {original_answer}

                Provide a complete, informative sentence that expands on the brief answer:
                """
        
        try:
            response = self.openai_client.chat.completions.create(
                model=self.model_key,
                messages=[
                    {"role": "system", "content": "You are a helpful sleep expert assistant. Provide clear, accurate, and detailed responses."},
                    {"role": "user", "content": prompt}
                ],
                max_tokens=200,
                temperature=0.7
            )
            
            enriched_answer = response.choices[0].message.content.strip()
            return enriched_answer
            
        except Exception as e:
            print(f"❌ Error enriching answer: {e}")
            return original_answer
    
    def _append_to_json_file(self, new_items: List[Dict], file_path: str):
        """Append new data to existing JSON file efficiently"""
        try:
            # Read existing data
            if os.path.exists(file_path):
                with open(file_path, 'r', encoding='utf-8') as f:
                    existing_data = json.load(f)
            else:
                existing_data = []
            
            # Add new data
            existing_data.extend(new_items)
            
            # Write back to file
            with open(file_path, 'w', encoding='utf-8') as f:
                json.dump(existing_data, f, indent=2, ensure_ascii=False)
                
        except Exception as e:
            print(f"❌ Error appending to JSON file: {e}")
    
