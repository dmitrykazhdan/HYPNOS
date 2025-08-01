# HYPNOS
Repository for the Hypnos Agent - an on-device multi-agent LLM system for managing sleep disorder


## Data Pre-Processing

### Data Enrichment

- Navigate into the `preprocessing` repo.
- Create a `.env` file inside the directory, and set your `OPENAI_API_KEY`
- Run the enrichment process with: `python main.py --csv sleep-data.csv --batch-size 5 --max-items 100`
- Output should be a `.json` with enriched items of the form:
```
  {
    "question": "what does help researchers to learn about the importance of sleep?",

    "answer": "Studying brain activity is a critical method that researchers use to gain insights into the significance of sleep, as it allows them to observe patterns and changes in neural processes that occur during different stages of sleep, helping to understand its essential role in cognitive function and overall health.",

    "source": "sleepqa_enriched",
    
    "original_answer": "brain activity"
  },
```

## Citing

If you find this code useful in your research, please cite:

```
@misc{kazhdan2025hypnos,
  author       = {Dmitry Kazhdan, Maria Chepurina},
  title        = {HYPNOS: A Question Answering Pipeline for Sleep Coaching},
  year         = 2025,
  url          = {https://github.com/dmitrykazhdan/HYPNOS}
}
```


If you use this repository or the SleepQA dataset in your research or application, please cite the following work:
```
@InProceedings{pmlr-v193-bojic22a,
  title = 	 {SleepQA: A Health Coaching Dataset on Sleep for Extractive Question Answering},
  author =       {Bojic, Iva and Ong, Qi Chwen and Thakkar, Megh and Kamran, Esha and Shua, Irving Yu Le and Pang, Jaime Rei Ern and Chen, Jessica and Nayak, Vaaruni and Joty, Shafiq and Car, Josip},
  booktitle = 	 {Proceedings of the 2nd Machine Learning for Health symposium},
  pages = 	 {199--217},
  year = 	 {2022},
  editor = 	 {Parziale, Antonio and Agrawal, Monica and Joshi, Shalmali and Chen, Irene Y. and Tang, Shengpu and Oala, Luis and Subbaswamy, Adarsh},
  volume = 	 {193},
  series = 	 {Proceedings of Machine Learning Research},
  month = 	 {28 Nov},
  publisher =    {PMLR},
  pdf = 	 {https://proceedings.mlr.press/v193/bojic22a/bojic22a.pdf},
  url = 	 {https://proceedings.mlr.press/v193/bojic22a.html}
}
```

