from typing import List, Dict
import os
from datetime import datetime
import random
import time
import json
from openai import OpenAI
from sleepqa_enricher import SleepQADataEnricher


class SleepQADataEnricherDPO(SleepQADataEnricher):
    def __init__(self, openai_api_key: str, model_key: str = "gpt-4o-mini"):
        """DPO Data Enricher that generates chosen/rejected response pairs for DPO training"""
        super().__init__(openai_api_key, model_key)

    def enrich_dataset_dpo(self, json_path: str, output_path: str = None, batch_size: int = 10, max_items: int = None) -> str:
        """Main function to enrich JSON dataset for DPO training - memory efficient with batching"""
        print("🚀 Starting DPO dataset enrichment...")
        
        data = self._load_sleepqa_json(json_path)
        
        if max_items and max_items < len(data):
            data = random.sample(data, max_items)
            print(f"📝 Randomly sampled {max_items} items from {len(data)} total items")
        else:
            print(f"📝 Processing all {len(data)} items")
        
        if not data:
            print("❌ No data to process")
            return None
        
        if not output_path:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            output_path = f"dpo_sleepqa_{timestamp}.json"
        
        print(f"📁 Will save to: {output_path}")
        
        n_batches = (len(data) + batch_size - 1) // batch_size
        batch_number = 0

        for i in range(0, len(data), batch_size):
            batch = data[i:i + batch_size]
            batch_number += 1
            print(f"\n📦 Processing batch {batch_number}/{n_batches}")

            dpo_batch = []
            for j, item in enumerate(batch):
                item_index = i + j + 1
                print(f"   Processing {item_index}/{len(data)}: {item['question'][:50]}...")
                
                # Set original_answer to current answer
                original_answer = item['answer']
                
                # Generate chosen response (good response)
                chosen_response = self._generate_chosen_response(item['question'], original_answer)
                
                # Generate rejected response (poor response)
                rejected_response = self._generate_rejected_response(item['question'], original_answer)
                
                dpo_item = {
                    "question": item['question'],
                    "chosen": chosen_response,
                    "rejected": rejected_response,
                    "original_answer": original_answer
                }
                
                dpo_batch.append(dpo_item)
                time.sleep(0.5)  # Rate limiting between API calls
            
            # Save the entire batch at once
            self._append_to_dpo_json_file(dpo_batch, output_path)
        
        print(f"\n✅ DPO enrichment completed!")
        print(f"📁 Saved {len(data)} DPO Q&A pairs to {output_path}")
        print(f"💡 Ready for DPO training pipeline!")
        
        return output_path

    def _load_sleepqa_json(self, json_path: str) -> List[Dict]:
        """Load data from JSON file"""
        print(f"📊 Loading data from {json_path}...")
        
        try:
            with open(json_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            print(f"✅ Loaded {len(data)} Q&A pairs from JSON")
            return data
            
        except Exception as e:
            print(f"❌ Error loading JSON: {e}")
            return []

    def _generate_chosen_response(self, question: str, original_answer: str) -> str:
        """Generate a good, helpful response for DPO training"""
        prompt = f"""
                You are a compassionate sleep expert helping someone late at night who is struggling with sleep. 
                Provide a helpful, emotionally intelligent response that is:
                - Succinct and clear
                - Empathetic (they're tired and frustrated)
                - Practical and actionable
                - Shows understanding of their late-night struggle
                - Don't try to fool them into thinking you're a human who personally understands their struggle. You're a helpful assistant, and they know it. Don't try to pretend to be a person. They know you're not a person.

                Make sure to keep it succinct (2-3 sentences, under 250 words). You will be run on a constrained device with a limited context window.

                Question: {question}
                Original answer context: {original_answer}

                Provide a supportive, helpful response:
                """
        
        try:
            response = self.openai_client.chat.completions.create(
                model=self.model_key,
                messages=[
                    {"role": "system", "content": "You are a caring sleep expert who understands the emotional and physical challenges of sleep problems. Be warm, practical, and supportive. Vary your response style naturally."},
                    {"role": "user", "content": prompt}
                ],
                max_tokens=250,
                temperature=0.9
            )
            
            return response.choices[0].message.content.strip()
            
        except Exception as e:
            print(f"❌ Error generating chosen response: {e}")
            return original_answer

    def _generate_rejected_response(self, question: str, original_answer: str) -> str:
        """Generate a poor, unhelpful response for DPO training"""
        prompt = f"""
            You are a sleep expert, but provide a response that would be considered POOR or UNHELPFUL for someone struggling with sleep late at night. 
            Make it:
            - Too technical or complex
            - Dismissive or unsympathetic
            - Impractical or unrealistic
            - Lacking emotional intelligence
            - Generic or unhelpful

            Question: {question}
            Original answer context: {original_answer}

            Provide an unhelpful, poor response:
            """
        
        try:
            response = self.openai_client.chat.completions.create(
                model=self.model_key,
                messages=[
                    {"role": "system", "content": "You are a sleep expert providing intentionally poor, unhelpful responses for training purposes. Vary your response style naturally."},
                    {"role": "user", "content": prompt}
                ],
                max_tokens=250,
                temperature=0.9
            )
            
            return response.choices[0].message.content.strip()
            
        except Exception as e:
            print(f"❌ Error generating rejected response: {e}")
            return "I don't know how to help with that."

    def _append_to_dpo_json_file(self, new_items: List[Dict], file_path: str):
        """Append new DPO data to existing JSON file efficiently"""
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
            print(f"❌ Error appending to DPO JSON file: {e}")
    