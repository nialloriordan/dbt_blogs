"""This module is used for running zero shot classification"""
import pandas as pd
import numpy as np
from transformers import pipeline
from transformers import set_seed
from tqdm import tqdm
import math


def candidate_labels_to_columns(candidate_labels: list, sort: bool = True) -> list:
    """Convert candidate labels to column names

    Args:
        candidate_labels (list): list of candidate labels

    Returns: list of column names
    """
    zero_shot_columns = [
        label.replace(" ", "_").replace("/", "_").lower() for label in candidate_labels
    ]  # replace spaces with underscores
    if sort:
        zero_shot_columns.sort()  # sort columns
    return zero_shot_columns


class model_inference:
    def __init__(
        self,
        text_docs,
        candidate_labels,
        model,
        tokeniser,
        multi_label=True,
        batch_size=4,
        seed_value=42,
        gpu_id=-1,
        text_column_name="zero_shot_text",
    ):
        self.text_docs = text_docs
        self.candidate_labels = candidate_labels
        self.multi_label = multi_label
        self.batch_size = batch_size
        self.seed_value = seed_value
        self.model = model
        self.tokenizer = tokeniser
        self.gpu_id = gpu_id
        self.text_column_name = text_column_name

    def _load_model(self):
        """Load model into memory

        Returns:
            transformers.pipelines.ZeroShotClassificationPipeline: zero shot learning model
        """
        set_seed(self.seed_value)
        classifier = pipeline(
            "zero-shot-classification",
            model=self.model,
            tokenizer=self.tokenizer,
            framework="pt",
            device=self.gpu_id,
        )
        return classifier

    def _split_data_batches(self, text_docs: list) -> list:
        """Split data into batches of a specified size

        Args:
            text_docs (list): list of text documents of type str

        Returns:
            list: list of np.array containting text documents
        """
        data_batches = np.array_split(
            text_docs,
            math.ceil(len(text_docs) / self.batch_size),
        )
        return data_batches

    def _predict_data_batches(self, data_chunks) -> list:
        """Make predictions in batches

        Args:
            data_chunks (list): list of np.array containting text documents

        Returns:
            list: list of model results
        """
        results = []
        text_desc = (
            "Classifying with CPU" if self.gpu_id == -1 else f"Classifying with GPU {self.gpu_id}"
        )
        for data in tqdm(
            data_chunks,
            total=len(data_chunks),
            desc=text_desc,
        ):
            chunk_size = len(data)
            result = self.classifier(
                list(data), self.candidate_labels, multi_label=self.multi_label
            )
            results.extend([result]) if chunk_size == 1 else results.extend(result)
        return results

    def _convert_model_results_df(self, results) -> pd.DataFrame:
        """Convert model results into a pandas dataframe

        Args:
            results (list): list of model results

        Returns:
            pd.DataFrame: dataframe of model results
        """
        # initialise dictionary with keys for each label and a text column
        # all items are initialised as empty lists so that they can be appended
        model_results = {label: [] for label in self.candidate_labels + [self.text_column_name]}

        # loop through all results and add scores and input text to dictionary
        for result in results:
            # append input text to dictionary
            model_results[self.text_column_name] += [result["sequence"]]
            # loop through all labels and add scores to dictionary
            for i, label in enumerate(result["labels"]):
                model_results[label] += [result["scores"][i]]

        # convert dictionary to pandas dataframe
        df = pd.DataFrame(model_results)
        # update column names by replacing spaces with underscores
        df.columns = candidate_labels_to_columns(df.columns, sort=False)
        return df

    def run(self):
        """Run zero shot learning pipeline

        Returns:
            pd.DataFrame: model results
        """
        # load model on GPU
        self.classifier = self._load_model()
        # split data into batches
        data_chunks = self._split_data_batches(self.text_docs)
        # label data in batches
        results = self._predict_data_batches(data_chunks)
        # convert results to dataframe
        df = self._convert_model_results_df(results)
        # sort columns
        sorted_columns = candidate_labels_to_columns(self.candidate_labels)
        sorted_columns.append(self.text_column_name)
        df = df[sorted_columns]
        return df
