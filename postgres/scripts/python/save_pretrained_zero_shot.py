"""This module is used for saving a zero shot model to disk for future use"""
from transformers import pipeline
from transformers import AutoTokenizer, AutoConfig
import argparse
import yaml


def save_zero_shot_model(model_name="facebook/bart-large-mnli", model_path="./zero-shot-model/"):
    """Save pretrained zero shot model to disk

    Args:
        model_name (str, optional): Name of sequence classification model. Defaults to "facebook/bart-large-mnli".
        model_path (str, optional): Local path to save model. Defaults to "./zero-shot-model/".
    """
    # load model
    classifier = pipeline(
        "zero-shot-classification",
        model=model_name,
        config=AutoConfig.from_pretrained(model_name),
        tokenizer=AutoTokenizer.from_pretrained(model_name),
        framework="pt",
    )
    # save model
    classifier.save_pretrained(model_path)


if __name__ == "__main__":
    # Parse command line arguments.
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-c", "--config", dest="config", help="Absolute path to configuration file."
    )
    args = parser.parse_args()

    # Ensure a config was passed to the script.
    if not args.config:
        print("No configuration file provided.")
        exit()
    else:
        with open(args.config, "r") as args:
            try:
                config = yaml.safe_load(args)
            except yaml.YAMLError as exc:
                print(exc)
                exit()

    save_zero_shot_model(**config)
